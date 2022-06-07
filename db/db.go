package db

import (
	"fmt"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"log"
)

type User struct {
	Id       int64  `db:"id"`
	Login    string `db:"login"`
	Password string `db:"password"`
	Token    string `db:"token"`
	Nick     string `db:"nick"`
}

type Message struct {
	Id     int64  `db:"id"`
	Text   string `db:"text"`
	UserId int64  `db:"user_id"`
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

func Test1() {
	//db, e := sqlx.Connect("postgres", "user=postgres password=postgres dbname=slick sslmode=disable")
	//checkError(e)

	message := []Message{}
	e = db.Select(&message, "SELECT * FROM message")
	checkError(e)

	for _, v := range message {
		fmt.Printf("%d: %v | USER_ID:%d\n", v.Id, v.Text, v.UserId)
	}
}

func checkError(e error) {
	if e != nil {
		log.Fatalln(e)
	}
}
