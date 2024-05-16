package main

import (
	LifeManager "LifeManager/API"
	LifeManagerdb "LifeManager/Script/DataBase"
)

func main() {
	LifeManagerdb.Create()
	// LifeManagerdb.CreateCategorieCourse()
	// LifeManagerdb.CreateCategorieDepense()
	// LifeManagerdb.CreateSousCategorieDepense()
	LifeManager.API()
}
