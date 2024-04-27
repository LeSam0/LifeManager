package main

import (
	LifeManager "LifeManager/API"
	LifeManagersc "LifeManager/Script/DataBase"
)

func main() {
	LifeManagersc.Create()
	LifeManager.API()
}
