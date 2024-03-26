package LifeManager

import (
	"database/sql"
)

type Login struct {
	NomApp      string `json:"NomApp,omitempty"`
	Identifiant string `json:"Identifiant,omitempty"`
	MotDePasse  string `json:"MotDePasse,omitempty"`
}

func NewLogin(NomApp string, Identifiant string, MotDePasse string) Login {
	login := Login{NomApp: NomApp, Identifiant: Identifiant, MotDePasse: MotDePasse}
	return login
}

func (Login Login) AddLoginToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO login (NomApp, identifiant, password) VALUES (?, ?, ?)", Login.NomApp, Login.Identifiant, Login.MotDePasse)
	if err != nil {
		panic(err)
	}
}

func SuppLoginToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM login WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Login Login) ModifLoginToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE login SET NomApp = ?, identifiant = ?, password = ? where id = ?", Login.NomApp, Login.Identifiant, Login.MotDePasse, id)
	if err != nil {
		panic(err)
	}
}

func GetLogin() []Login {
	var log []Login
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT NomApp, Identifiant, password FROM login")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var login Login
		err = rows.Scan(&login.NomApp, &login.Identifiant, &login.MotDePasse)
		if err != nil {
			panic(err)
		}
		log = append(log, login)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return log
}

