package LifeManager

import (
	"io/ioutil"
	"math/rand"
	"os"
	"strings"
)

var chiffre = []string{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
var majuscule = []string{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
var minuscule = []string{"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
var caractèrespé = []string{"!", "\"", "#", "$", "%", "&", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "=", "?", "@", "[", "]", "^", "_", "`", "{", "|", "}", "~", "'"}

func Generatemdp() string {
	var mdp []string
	for i := 0; i <= 23; i++ {
		rdmnumber := (rand.Intn(4-0) + 0)
		if rdmnumber == 1 {
			rdmc := chiffre[rand.Intn(len(chiffre))]
			mdp = append(mdp, rdmc)
		} else if rdmnumber == 2 {
			rdmM := majuscule[rand.Intn(len(majuscule))]
			mdp = append(mdp, rdmM)
		} else if rdmnumber == 3 {
			rdmm := minuscule[rand.Intn(len(minuscule))]
			mdp = append(mdp, rdmm)
		} else if rdmnumber == 0 {
			rdmc := caractèrespé[rand.Intn(len(caractèrespé))]
			mdp = append(mdp, rdmc)
		}
	}
	if !Checkifnotdouble(Checkifmdpok(mdp)) {
		Generatemdp()
	}
	return Checkifmdpok(mdp)
}

func contains(s []string, elem string) bool {
	for _, a := range s {
		if a == elem {
			return true
		}
	}
	return false
}

func Checkifmdpok(mdp []string) string {
	checkchif := false
	checkmaj := false
	checkmin := false
	checkcarspé := false
	for i := 0; i <= 23; i++ {
		if contains(chiffre, mdp[i]) {
			checkchif = true
			break
		}
		if contains(majuscule, mdp[i]) {
			checkmaj = true
			break
		}
		if contains(minuscule, mdp[i]) {
			checkmin = true
			break
		}
		if contains(caractèrespé, mdp[i]) {
			checkcarspé = true
			break
		}
	}
	if checkchif && checkcarspé && checkmaj && checkmin {
		TabToString(mdp)
	} else {
		rdmp := rand.Intn(17)
		if !checkcarspé {  
			rdmc := caractèrespé[rand.Intn(len(caractèrespé)-1)]
			mdp[rdmp] = rdmc
		} else if !checkmin {
			rdmm := minuscule[rand.Intn(len(minuscule)-1)]
			mdp[rdmp] = rdmm
		} else if !checkmaj {
			rdmM := majuscule[rand.Intn(len(majuscule)-1)]
			mdp[rdmp] = rdmM
		} else if !checkchif {
			rdmc := chiffre[rand.Intn(len(chiffre)-1)]
			mdp[rdmp] = rdmc
		}
		return TabToString(mdp)
	}
	return ""
}

func TabToString(tab []string) string {
	finmdp := ""
	for _, char := range tab {
		finmdp += char
	}
	return finmdp
}

func Checkifnotdouble(mdp string) bool {
	test := false
	if _, err := os.Stat("liste_mdp.txt"); err == nil {
		content, _ := ioutil.ReadFile("liste_mdp.txt")
		for _, e := range strings.Split(string(content), "\n") {
			check := true
			if e == mdp {
				check = false
				break
			}
			if check {
				ioutil.WriteFile("liste_mdp.txt", []byte(string(content)+"\n"+mdp), 0777)
				test = true
			}
		}
	} else {
		f, _ := os.Create("liste_mdp.txt")
		f.WriteString("LISTE DE COURSE" + "\n")
		defer f.Close()
		Checkifnotdouble(mdp)
	}
	return test
}

// func Hashmdp(finmdp string){
// 	hash := sha256.New()
//     sum := hash.Sum(nil)
// 	fmt.Printf("%x\n", sum)
// }


