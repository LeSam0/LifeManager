package main

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3@latest"
)

var Database *sql.DB

func main() {
	db, err := sql.Open("sqlite3", "lifeManager.db")
	if err != nil {
		log.Fatal(err)
	}


	Database = db
	defer db.Close()
	// Create table User
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, email TEXT, Token TEXT, Country TEXT, Gender TEXT,Age INTEGER,Bio TEXT)")
	if err != nil {
		panic(err)
	}
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Table User created successfully")
	// Create table Msg
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS message (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, idofuser INTEGER, Message TEXT, idTopic INTEGER)")
	if err != nil {
		panic(err)
	}
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Table Msg created successfully")
	// Create table Categorie
		_, err = db.Exec("CREATE TABLE IF NOT EXISTS Categorie (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT)")
		if err != nil {
			panic(err)
		}
		if err != nil {
			log.Fatal(err)
		}
		log.Println("Table User created successfully")
	// Create table Topic
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS topic (id INTEGER PRIMARY KEY AUTOINCREMENT, topicsubject TEXT, categorie INTEGER)")
	if err != nil {
		panic(err)
	}
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Table Topic created successfully")
	// Create table TopicLiked
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS topicliked (id INTEGER PRIMARY KEY AUTOINCREMENT, idofusername INTEGER, idoftopicliked INTEGER)")
	if err != nil {
		panic(err)
	}
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Table messageliked created successfully")
	// Create table Topic
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS msglike (id INTEGER PRIMARY KEY AUTOINCREMENT, idofmessage INTEGER, idofuser INTEGER)")
	if err != nil {
		panic(err)
	}
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Table msglike created successfully")
	// Create table TopicLiked
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS administration (id INTEGER PRIMARY KEY AUTOINCREMENT, idofusername INTEGER, Power INTEGER)")
	if err != nil {
		panic(err)
	}
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Table Administration created successfully")
	//insert topic
	//Createatopic("")
}
