package LifeManager

import (
	"database/sql"
	"time"

	_ "github.com/mattn/go-sqlite3"
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

func SuppDepensesToDB(id string) {
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
	_, err = db.Exec("UPDATE depenses SET Nom = ? , Montant = ? , Date = ?, Description = ?, id_sous_categorie = ? where id = ?", Liste.Nom, Liste.Montant, Liste.Date, Liste.Description, Liste.Id_sous_categorie, id)
	if err != nil {
		panic(err)
	}
}

func GetDepenseJour(date string) []Depenses {
	depenses := GetAllDepense()
	var finaldepenses []Depenses
	for _, depense := range depenses {
		if depense.Date.Format("2006-02-01") == date {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}

func GetDepenseMois(mois string) []Depenses {
	depenses := GetAllDepense()
	var finaldepenses []Depenses
	for _, depense := range depenses {
		if depense.Date.Format("01") == mois {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}

func GetDepenseAnnee(annee string) []Depenses {
	depenses := GetAllDepense()
	var finaldepenses []Depenses
	for _, depense := range depenses {
		if depense.Date.Format("2006") == annee {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}

func GetAllDepense() []Depenses {
	var depenses []Depenses
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT Nom, Montant, Date, Description, id_sous_categorie FROM depenses")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var depense Depenses
		err = rows.Scan(&depense.Nom, &depense.Montant, &depense.Date, &depense.Description, &depense.Id_sous_categorie)
		if err != nil {
			panic(err)
		}
		depenses = append(depenses, depense)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return depenses
}

func GetSousCategorieDepense(id_categorie string) []Categorie {
	var souscategories []Categorie
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id, type FROM sous_categorie_depense WHERE id_categorie = ?", id_categorie)
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var souscategorie Categorie
		err = rows.Scan(&souscategorie.Id, &souscategorie.Categorie_Name)
		if err != nil {
			panic(err)
		}
		souscategories = append(souscategories, souscategorie)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return souscategories
}

func GetCategorieDepense() []Categorie {
	var categories []Categorie
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM categorie_depense")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var categorie Categorie
		err = rows.Scan(&categorie.Id, &categorie.Categorie_Name)
		if err != nil {
			panic(err)
		}
		categories = append(categories, categorie)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return categories
}
