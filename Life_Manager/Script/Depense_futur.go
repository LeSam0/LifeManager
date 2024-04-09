package LifeManager

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

func (Liste Depenses) AddFuturToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO depenses_futur (Nom, Montant, Date, Description, id_sous_categorie) VALUES (?, ?, ?, ?, ?)", Liste.Nom, Liste.Montant, Liste.Date, Liste.Description, Liste.Id_sous_categorie)
	if err != nil {
		panic(err)
	}
}

func SuppFuturDepensesToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM depenses_futur WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Liste Depenses) ModifFuturToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE depenses_futur SET Nom = ? , Montant = ? , Date = ?, Description = ?, id_sous_categorie = ? where id = ?", Liste.Nom, Liste.Montant, Liste.Date, Liste.Description, Liste.Id_sous_categorie, id)
	if err != nil {
		panic(err)
	}
}

func GetFuturDepenseJour(date string) []Depenses {
	depenses := GetAllDepense()
	var finaldepenses []Depenses
	for _, depense := range depenses {
		if depense.Date.Format("2006-02-01") == date {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}

func GetFuturDepenseMois(mois string) []Depenses {
	depenses := GetAllDepense()
	var finaldepenses []Depenses
	for _, depense := range depenses {
		if depense.Date.Format("01") == mois {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}

func GetFuturDepenseAnnee(annee string) []Depenses {
	depenses := GetAllDepense()
	var finaldepenses []Depenses
	for _, depense := range depenses {
		if depense.Date.Format("2006") == annee {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}

func GetFuturAllDepense() []Depenses {
	var depenses []Depenses
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT Nom, Montant, Date, Description, id_sous_categorie FROM depenses_futur")
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
