package LifeManager

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"os/exec"
)

type MDP struct {
	MotDePasse string `json:"MotDePasse,omitempty"`
}

func Newmdp() MDP {
	cmd := exec.Command("python", "./MotDePasse.py")
	out, err := cmd.Output()
	if err != nil {
		panic(err.Error())
	}
	return MDP{MotDePasse: string(out)}
}

var BobPrivKey, BobPubKey = genKeys()

func ChiffrementMDP(mdp string) string {
	Mdpchiffre, _ := rsa.EncryptOAEP(sha256.New(), rand.Reader, BobPubKey, []byte(mdp), []byte{})
	return string(Mdpchiffre)
}

func DeChiffrementMDP(mdp string) string {
	Mdpdechiffre, _ := rsa.DecryptOAEP(sha256.New(), rand.Reader, BobPrivKey, []byte(mdp), []byte{})
	return string(Mdpdechiffre)
}
