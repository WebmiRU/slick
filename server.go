package main

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"prj1/db"
	_ "prj1/db"
)

type Message struct {
	Type   string `json:"type"`
	Token  string `json:"token"`
	Target string `json:"target"`
	Text   string `json:"text"`
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
			} else {
				users[conn] = user
			}
		}

		fmt.Println(users[conn].Nick)

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
		var m Message
		if e = conn.ReadJSON(&m); e != nil {
			fmt.Println("Message decode error", e)
			continue
		}

		processMessage(m, conn)
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
	db.Test1()

	http.HandleFunc("/socket", socketHandler)
	http.HandleFunc("/SOCKET", socketHandler)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe("localhost:8924", nil))
}
