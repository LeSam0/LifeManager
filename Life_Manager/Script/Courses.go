package LifeManager

import (
	"database/sql"
)

type Categorie struct {
	Id             int    `json:"Id,omitempty"`
	Categorie_Name string `json:"Categorie_Name,omitempty"`
}

type Articles struct {
	Categorie    string  `json:"Categorie_Name,omitempty"`
	Id           int     `json:"Id,omitempty"`
	Categorie_id int     `json:"Categorie_Id,omitempty"`
	Article      string  `json:"Article,omitempty"`
	Prix         float64 `json:"Prix,omitempty"`
	Quantite     int     `json:"Quantite,omitempty"`
	Favorie		 bool	 `json:"Favorie,omitempty"`
}

func NewArticle(Categorie_id int, Article string, Prix float64, Quantite int, Favorie bool) Articles {
	liste := Articles{Categorie_id: Categorie_id, Article: Article, Prix: Prix, Quantite: Quantite, Favorie: Favorie}
	return liste
}

func (Liste Articles) AddToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO courses (categorie_id, article, prix, quantite, favorie) VALUES (?, ?, ?, ?, ?)", Liste.Categorie_id, Liste.Article, Liste.Prix, Liste.Quantite, Liste.Favorie)
	if err != nil {
		panic(err)
	}
}

func SuppToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM courses WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Liste Articles) ModifToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE courses SET categorie_id = ?, article = ?, prix = ?, quantite = ?, favorie = ? where id = ?", Liste.Categorie_id, Liste.Article, Liste.Prix, Liste.Quantite, Liste.Favorie,id)
	if err != nil {
		panic(err)
	}
}

func GetAllCourse() []Articles {
	var articles []Articles
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id, categorie_id, article, prix, quantite FROM courses")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var article Articles
		err = rows.Scan(&article.Id, &article.Categorie_id, &article.Article, &article.Prix, &article.Quantite)
		if err != nil {
			panic(err)
		}
		articles = append(articles, article)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return articles
}

func GetCategorie() []Categorie {
	var categories []Categorie
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM categorie_course")
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

func GetCategoriebyId(id int) string {
	name := ""
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT type FROM categorie_course WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		err = rows.Scan(&name)
		if err != nil {
			panic(err)
		}
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return name
}

func GetListeByCategorie() []Articles {
	liste_course := GetAllCourse()
	for _, element := range liste_course {
		element.Categorie = GetCategoriebyId(element.Categorie_id)
	}
	return liste_course
}
