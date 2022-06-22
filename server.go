package main

import (
	"fmt"
	"log"
	"net/http"
	"prj1/db"

	"github.com/gorilla/websocket"
)

type Message struct {
	Type   string `json:"type"`
	Token  string `json:"token"`
	Target string `json:"target"`
	Id     int64  `json:"id"`
	Value  string `json:"value"`
	Offset string `json:"offset"`
}

type SystemMessage struct {
	Type    string `json:"type"`
	Target  string `json:"target"`
	Message string `json:"message"`
}

type TextMessage struct {
	Type   string `json:"type"`
	Target string `json:"target"`
	Id     int64  `json:"id"`
	Value  string `json:"value"`
	UserId int64  `json:"user_id"`
}

type ResponseData struct {
	Type   string      `json:"type"`
	Target string      `json:"target"`
	Id     int64       `json:"id"`
	Data   interface{} `json:"data"`
}

var upgrader = websocket.Upgrader{} // use default options
var users = map[*websocket.Conn]*db.User{}
var channels = map[int64][]*websocket.Conn{}

func checkUserAuth() {

}

func processMessage(message Message, conn *websocket.Conn) {
	fmt.Printf("%v\n", message)

	switch message.Type {
	case "AUTH":
		fmt.Println("AUTH MESSAGE")

		if _, ok := users[conn]; !ok {
			fmt.Println("User AUTH procedure start")

			var user = db.UserAuth(message.Token)

			if user == nil {
				fmt.Println("User AUTH error")
				conn.WriteJSON(SystemMessage{
					Type:    "ERROR",
					Target:  "AUTH",
					Message: "Auth error, token incorrect",
				})

				conn.Close()
				return
			}

			fmt.Println("User auth success")

			users[conn] = user
			chs := db.GetUserChannelList(users[conn].Id)

			//@TODO возможно нужен Mutex
			for _, ch := range *chs {
				channels[ch.Id] = append(channels[ch.Id], conn)
			}

			conn.WriteJSON(SystemMessage{
				Type:    "SUCCESS",
				Target:  "AUTH",
				Message: "Auth successfully",
			})

		}

		fmt.Println(users[conn].Nick)

	case "REQUEST":
		switch message.Target {
		case "CHANNEL_LIST":
			conn.WriteJSON(ResponseData{
				Type:   "RESPONSE",
				Target: "CHANNEL_LIST",
				Data:   db.GetUserChannelList(users[conn].Id),
			})

		case "CHANNEL_MESSAGES":
			conn.WriteJSON(ResponseData{
				Type:   "RESPONSE",
				Target: "CHANNEL_MESSAGES",
				Id:     message.Id,
				Data:   db.GetMessageChannelList(users[conn].Id, message.Id),
			})
		}

	case "MESSAGE":
		switch message.Target {
		case "CHANNEL":
			for _, c := range channels[message.Id] {
				c.WriteJSON(TextMessage{
					Type:   "MESSAGE",
					Target: "CHANNEL",
					Id:     message.Id, // Channel ID
					Value:  message.Value,
					UserId: users[conn].Id,
				})
			}

		case "PRIVATE":
			senderId := users[conn].Id
			receiverId := message.Id

			//Getting interlocutors id from the client side request
			interlocutorsId := map[int64]bool{senderId: true, receiverId: true}
			//Interlocutors connections
			var interlocutorsConn []*websocket.Conn

			//Now we finding websocket connections with sender and receiver
			for conn, user := range users {
				if _, ok := interlocutorsId[user.Id]; ok {
					interlocutorsConn = append(interlocutorsConn, conn)
				}
			}
			for _, c := range interlocutorsConn {
				c.WriteJSON(TextMessage{
					Type:   "MESSAGE",
					Target: "PRIVATE",
					Id:     receiverId, // receiver user ID
					Value:  message.Value,
					UserId: senderId,
				})
			}
			// db.SendPrivateMessage(message.Value, senderId, receiverId)
		}
	default:
		fmt.Println("OTHER MESSAGE")
	}
}

func socketHandler(w http.ResponseWriter, r *http.Request) {
	upgrader.CheckOrigin = func(r *http.Request) bool { return true } // allow any connections into websocket
	conn, e := upgrader.Upgrade(w, r, nil)
	checkError(e)

	defer conn.Close()

	for {
		var message Message
		if e = conn.ReadJSON(&message); e != nil {
			fmt.Println("Message decode error", e)
			continue
		}

		processMessage(message, conn)
	}
}

func checkError(e error) {
	if e != nil {
		log.Printf("%v\n", e)
		fmt.Printf("%v\n", e)
	}
}

func home(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Index Page")
}

func main() {
	http.HandleFunc("/socket", socketHandler)
	http.HandleFunc("/SOCKET", socketHandler)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe("localhost:8924", nil))
}
