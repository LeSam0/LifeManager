package LifeManager

import (
	LifeManager "LifeManager/Script"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
)

func Tesr() {

	// Login

	http.HandleFunc("/login/create", CreateLogin)
	http.HandleFunc("/login/get", GetAllLogin)
	http.HandleFunc("/login/update", UpdateLogin)
	http.HandleFunc("/login/delete", DeleteLogin)

	// Mdp

	http.HandleFunc("/login/motdepasse", GetMotdePasse)

	// Categorie

	http.HandleFunc("/courses/categorie", GetAllCategorie)

	// Course

	http.HandleFunc("/courses/create", CreateCourse)
	http.HandleFunc("/courses/get", GetAllCourse)
	http.HandleFunc("/courses/update", UpdateCourse)
	http.HandleFunc("/courses/delete", DeleteCourse)

	// Course Fav

	http.HandleFunc("/courses/favori/create", CreateCourseFav)
	http.HandleFunc("/courses/favori/get", GetAllCourseFav)
	http.HandleFunc("/courses/favori/update", UpdateCourseFav)
	http.HandleFunc("/courses/favori/delete", DeleteCourseFav)

	log.Fatal(http.ListenAndServe(":8000", nil))
}

func CreateLogin(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		NomApp := r.URL.Query().Get("nomapp")
		Identifiant := r.URL.Query().Get("identifiant")
		MotDePasse := r.URL.Query().Get("motdepasse")
		newLogin := LifeManager.NewLogin(NomApp, Identifiant, MotDePasse)
		newLogin.AddLoginToDB()
	}
}

func UpdateLogin(w http.ResponseWriter, r *http.Request) {
	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		NomApp := r.URL.Query().Get("nomapp")
		Identifiant := r.URL.Query().Get("identifiant")
		MotDePasse := r.URL.Query().Get("motdepasse")
		newLogin := LifeManager.NewLogin(NomApp, Identifiant, MotDePasse)
		newLogin.ModifLoginToDB(id)
	}
}

func DeleteLogin(w http.ResponseWriter, r *http.Request) {

	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppLoginToDB(id)
	}
}

func GetAllLogin(w http.ResponseWriter, r *http.Request) {

	if r.Method == "GET" {
		liste_Login := LifeManager.GetLogin()
		json.NewEncoder(w).Encode(liste_Login)
	}
}

func GetMotdePasse(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		Mdp := LifeManager.Newmdp()
		json.NewEncoder(w).Encode(Mdp)
	}
}

func CreateCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/create?categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Post
	if r.Method == "POST" {
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite)
		newArticle.AddToDB()
	}
}

func UpdateCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/update?id=1&categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Put
	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite)
		newArticle.ModifToDB(id)
	}
}

func DeleteCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/delete?id=1
	// Methode := Delete
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppToDB(id)
	}
}

func GetAllCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/get
	// Methode := Get
	if r.Method == "GET" {
		Liste_course := LifeManager.GetListeByCategorie()
		json.NewEncoder(w).Encode(Liste_course)
	}
}

func CreateCourseFav(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/create?categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Post

	Liste := LifeManager.GetListeFavByCategorie()
	Nb_article_fav := 0
	for _, Categorie := range Liste {
		for range Categorie.Article {
			Nb_article_fav++
		}
	}
	if Nb_article_fav < 5 {
		if r.Method == "POST" {
			categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
			article := r.URL.Query().Get("article")
			prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
			quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
			newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite)
			newArticle.AddFavToDB()
		}
	}
}

func UpdateCourseFav(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/update?id=1&categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Put
	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite)
		newArticle.ModifFavToDB(id)
	}
}

func DeleteCourseFav(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/delete?id=1
	// Methode := Delete
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppFavToDB(id)
	}
}

func GetAllCourseFav(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/get
	// Methode := Get
	if r.Method == "GET" {
		Liste_course := LifeManager.GetListeFavByCategorie()
		json.NewEncoder(w).Encode(Liste_course)
	}
}

func GetAllCategorie(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		AllCategorie := LifeManager.GetCategorie()
		json.NewEncoder(w).Encode(AllCategorie)
	}
}
