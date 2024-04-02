package LifeManager

import (
	"database/sql"
	"time"
)

type Depenses struct {
	Nom               string
	Montant           float64
	Date              time.Time
	Description       string
	Id_sous_categorie int
}

func NewDepenses(Nom string, Montant float64, Date time.Time, Description string, Id_Sous_Categorie int) Depenses {
	liste := Depenses{Nom: Nom, Montant: Montant, Date: Date, Description: Description, Id_sous_categorie: Id_Sous_Categorie}
	return liste
}

func (Liste Depenses) AddToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO depenses (Nom, Montant, Date, Description, id_sous_categorie) VALUES (?, ?, ?, ?, ?)", Liste.Nom, Liste.Montant, Liste.Date, Liste.Description, Liste.Id_sous_categorie)
	if err != nil {
		panic(err)
	}
}

func (Liste Depenses) SuppToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM depenses WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Liste Depenses) ModifToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE depenses SET Nom = ? , Montant = ? , Date = ?, Description = ?, id_sous_categorie = ? where id = ?", Liste.Nom, Liste.Montant, Liste.Date, Liste.Description, Liste.Id_sous_categorie ,id)
	if err != nil {
		panic(err)
	}
}
