package LifeManager

import (
	LifeManager "LifeManager/Script"
	"crypto/md5"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"fmt"
	"strings"
)

type FileName struct {
	id       int
	filename string
}

type FileDos struct {
	truefilename string
	filename     []string
}

func DeSecureFile() {
	files := GetAllFileName()
	filesdb := GetAllFileNameFormDB()
	FilesDos := GetFileTodeSecure(files, filesdb)
	RSA := LifeManager.GetRSA()
	privkey, _ := LifeManager.ParseRsaPrivateKeyFromPemStr(RSA.Prikey)
	for _, file := range FilesDos {
		result := GetOrderOfFile(file)
		contenu := []byte{}
		for _, f := range result.filename {
			save, _ := ReadFileAndReturnByteArray(f)
			save = DeChiffrement(save, privkey)
			contenu = append(contenu, save...)
			RemouveFile(f)
		} 
		WriteInFile(contenu, result.truefilename)
		
	}
}

func GetAllFileNameFormDB() []FileName {
	var FilesName []FileName
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM secure_chest")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	var FileName FileName
	for rows.Next() {
		err = rows.Scan(&FileName.id, &FileName.filename)
		if err != nil {
			panic(err)
		}
		FilesName = append(FilesName, FileName)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return FilesName
}

func GetFileTodeSecure(files []string, filesdb []FileName) []FileDos {
	var FilesDos []FileDos
	var FileDos FileDos
	for _, filedb := range filesdb {
		filedbmd5 := StringToMd5(filedb.filename)
		for _, file := range files {
			if strings.Contains(filedbmd5, file) {
				FileDos.filename = append(FileDos.filename, file)
				FileDos.truefilename = filedb.filename
			}
		}
		FilesDos = append(FilesDos, FileDos)
	}
	return FilesDos
}

func GetOrderOfFile(filesname FileDos) FileDos {
	var result FileDos
	filenamemd5 := StringToMd5(filesname.truefilename)
	if (filesname.filename[0] + filesname.filename[1] + filesname.filename[2]) == filenamemd5 {
		result.filename = append(result.filename, filesname.filename[0])
		result.filename = append(result.filename, filesname.filename[1])
		result.filename = append(result.filename, filesname.filename[2])
	} else if (filesname.filename[0] + filesname.filename[2] + filesname.filename[1]) == filenamemd5 {
		result.filename = append(result.filename, filesname.filename[0])
		result.filename = append(result.filename, filesname.filename[2])
		result.filename = append(result.filename, filesname.filename[1])
	} else if (filesname.filename[1] + filesname.filename[2] + filesname.filename[0]) == filenamemd5 {
		result.filename = append(result.filename, filesname.filename[1])
		result.filename = append(result.filename, filesname.filename[2])
		result.filename = append(result.filename, filesname.filename[0])
	} else if (filesname.filename[1] + filesname.filename[0] + filesname.filename[2]) == filenamemd5 {
		result.filename = append(result.filename, filesname.filename[1])
		result.filename = append(result.filename, filesname.filename[0])
		result.filename = append(result.filename, filesname.filename[2])
	} else if (filesname.filename[2] + filesname.filename[0] + filesname.filename[1]) == filenamemd5 {
		result.filename = append(result.filename, filesname.filename[2])
		result.filename = append(result.filename, filesname.filename[0])
		result.filename = append(result.filename, filesname.filename[1])
	} else if (filesname.filename[2] + filesname.filename[1] + filesname.filename[0]) == filenamemd5 {
		result.filename = append(result.filename, filesname.filename[2])
		result.filename = append(result.filename, filesname.filename[1])
		result.filename = append(result.filename, filesname.filename[0])
	}
	result.truefilename = filesname.truefilename
	return result
}

func StringToMd5(filename string) string {
	hasher := md5.New()
	hasher.Write([]byte(filename))
	return hex.EncodeToString(hasher.Sum(nil))
}

func DeChiffrement(Filedata []byte, PrivKey *rsa.PrivateKey) []byte {
	datadechiffre, err := rsa.DecryptOAEP(sha256.New(), rand.Reader, PrivKey, Filedata, []byte{})
	if err != nil {
		fmt.Println(err)
	}
	return datadechiffre
}
