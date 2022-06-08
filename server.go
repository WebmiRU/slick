package main

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"prj1/db"
)

type Message struct {
	Type   string `json:"type"`
	Token  string `json:"token"`
	Target string `json:"target"`
	Id     int64  `json:"id"`
	Text   string `json:"text"`
	Offset string `json:"offset"`
}

type ResponseData struct {
	Type   string      `json:"type"`
	Target string      `json:"target"`
	Id     int64       `json:"id"`
	Data   interface{} `json:"data"`
}

var upgrader = websocket.Upgrader{} // use default options
var users = map[*websocket.Conn]*db.User{}

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
				//conn.Close()
				return
			}

			fmt.Println("User auth success")

			users[conn] = user

			conn.WriteJSON(ResponseData{
				Type:   "SUCCESS",
				Target: "AUTH",
			})

		}

		fmt.Println(users[conn].Nick)

	case "REQUEST":
		switch message.Target {
		case "CHANNEL_LIST":
			conn.WriteJSON(ResponseData{
				Type:   "RESPONSE",
				Target: "CHANNEL_LIST",
				Data:   db.GetUserChannelList(1),
			})

		case "CHANNEL_MESSAGES":
			conn.WriteJSON(ResponseData{
				Type:   "RESPONSE",
				Target: "CHANNEL_MESSAGES",
				Id:     message.Id,
				Data:   db.GetMessageChannelList(1, message.Id),
			})
		}

	default:
		fmt.Println("OTHER MESSAGE")
	}
}

func socketHandler(w http.ResponseWriter, r *http.Request) {
	upgrader.CheckOrigin = func(r *http.Request) bool { return true }
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

//e = conn.WriteMessage(websocket.TextMessage, []byte(fmt.Sprintf("%s %s %s", ">>>", message, "<<<")))

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
