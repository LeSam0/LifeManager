package LifeManager

import (
	"database/sql"
	"strconv"
)

type RSA struct {
	Prikey string
	Pubkey string
}

type LoginForRSA struct {
	id          int
	nomapp      string
	identifiant string
	mdp         string
}

type User struct {
	name     string
	password string
	pubkey   string
	privkey  string
}

func CreateUser(name string, password string) User {
	newprivkey, newpubkey := genKeys()
	newprivkeystr := ExportRsaPrivateKeyAsPemStr(newprivkey)
	newpubkeystr, _ := ExportRsaPublicKeyAsPemStr(newpubkey)
	return User{name: name, password: password, pubkey: newpubkeystr, privkey: newprivkeystr}
}

func (User User) AddUserToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO user (username, password, pubkeyrsa, privkeyrsa) VALUES (?, ?, ?, ?)", User.name, User.password, User.pubkey, User.privkey)
	if err != nil {
		panic(err)
	}
}

func ChangeNewKey() {
	newprivkey, newpubkey := genKeys()
	rsa := GetRSA()
	lastprivkey, _ := ParseRsaPrivateKeyFromPemStr(rsa.Prikey)
	Log := GetLoginWithID()
	for _, login := range Log {
		mdpdechif := DeChiffrementMDP(login.mdp, lastprivkey)
		loginmodif := NewLogin(login.nomapp, login.identifiant, ChiffrementMDP(mdpdechif, newpubkey))
		id := strconv.Itoa(login.id)
		loginmodif.ModifLoginToDB(id)
	}
	newpubkeystr, _ := ExportRsaPublicKeyAsPemStr(newpubkey)
	ModifRSAToDB(ExportRsaPrivateKeyAsPemStr(newprivkey), newpubkeystr)
}
