package db

import (
	"fmt"
	"log"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

type User struct {
	Id       int64  `db:"id"`
	Login    string `db:"login"`
	Password string `db:"password"`
	Token    string `db:"token"`
	Nick     string `db:"nick"`
}

type Channel struct {
	Id    int64  `db:"id" json:"id"`
	Title string `db:"title" json:"title"`
}

type Message struct {
	Id     int64  `db:"id"`
	Value  string `db:"value"`
	UserId int64  `db:"user_id"`
}

type MessageChannel struct {
	Id        int64  `db:"id" json:"id"`
	UserId    int64  `db:"user_id" json:"user_id"`
	ChannelId int64  `db:"channel_id" json:"channel_id"`
	Value     string `db:"value" json:"value"`
}

var db, e = sqlx.Connect("postgres", "user=postgres password=postgres dbname=slick sslmode=disable")

func init() {
	if e != nil {
		fmt.Println("ERROR!")
		//os.Exit(99)
		fmt.Printf("%v\n", e)
	}
}

func UserAuth(token string) *User {
	var user User
	if e = db.Get(&user, `SELECT * FROM "user" WHERE "token" = $1`, token); e != nil {
		fmt.Printf("%v\n", e)
		return nil
	}

	return &user
}

func GetUserChannelList(userId int64) *[]Channel {
	var channels []Channel
	e = db.Select(&channels, `SELECT id, title FROM view_user_channel  WHERE user_id = $1`, userId)

	if e != nil {
		fmt.Println(e)
	}

	return &channels
}

func GetMessageChannelList(userId int64, channelId int64) *[]MessageChannel {
	var messages []MessageChannel

	e = db.Select(&messages, `SELECT * FROM message_channel WHERE channel_id = $1 ORDER BY id DESC`, channelId)

	if e != nil {
		fmt.Println(e)
	}

	return &messages
}

func SavePrivateMessage() {

}

func checkError(e error) {
	if e != nil {
		log.Fatalln(e)
	}
}
