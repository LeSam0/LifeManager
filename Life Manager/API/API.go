package main

import (
	LifeManager "LifeManager/Script"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"github.com/gorilla/mux"
)

func main() {
	router := mux.NewRouter()

	router.HandleFunc("/courses", CreateCourse).Methods(http.MethodPost)
	router.HandleFunc("/courses", GetAllCourse).Methods(http.MethodGet)
	router.HandleFunc("/courses/{id}", UpdateCourse).Methods(http.MethodPut)
	router.HandleFunc("/courses/{id}", DeleteCourse).Methods(http.MethodDelete)

	log.Fatal(http.ListenAndServe(":8000", router))
}

func CreateCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses?categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Post

	categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
	article := r.URL.Query().Get("article")
	prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
	quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
	newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite)
	newArticle.AddToDB()
}

func UpdateCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses?categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Put

	params := mux.Vars(r)
	categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
	article := r.URL.Query().Get("article")
	prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
	quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
	newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite)
	newArticle.ModifToDB(params["id"])
}

func DeleteCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses
	// Methode := Delete

	params := mux.Vars(r)
	LifeManager.SuppToDB(params["id"])
}

func GetAllCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses
	// Methode := Get

	Liste_course := LifeManager.GetListeByCategorie()
	json.NewEncoder(w).Encode(Liste_course)
}
