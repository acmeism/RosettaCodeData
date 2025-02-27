/*
 Only use ASCII letters between A and Z or the Characters in square... . If the row with 'J' is removed from the squares,
 then the square is a 'Polybios square' and you must use removeSpaceI(text) to encrypt and decrypt
*/
package main

import (
	"fmt"
	"strings"
)

var (
	squareRosetta [][]byte = [][]byte{ //rosettacode
		{'A', 'B', 'C', 'D', 'E'},
		{'F', 'G', 'H', 'I', 'K'},
		{'L', 'M', 'N', 'O', 'P'},
		{'Q', 'R', 'S', 'T', 'U'},
		{'V', 'W', 'X', 'Y', 'Z'},
		{'J', '1', '2', '3', '4'},
	}

	squareWikipedia [][]byte = [][]byte{ // wikipedia

		{'B', 'G', 'W', 'K', 'Z'},
		{'Q', 'P', 'N', 'D', 'S'},
		{'I', 'O', 'A', 'X', 'E'},
		{'F', 'C', 'L', 'U', 'M'},
		{'T', 'H', 'Y', 'V', 'R'},
		{'J', '1', '2', '3', '4'},
	}

	textRosetta          string = "0ATTACKATDAWN"
	textRosettaEncoded   string = "DQBDAXDQPDQH" // only for test
	textWikipedia        string = "FLEEATONCE"
	textWikipediaEncoded string = "UAEOLWRINS" // only for test
	textTest             string = "The invasion will start on the first of January"
	textTextEncoded      string = "RASOAQXFIOORXESXADETSWLTNIAZQOISBRGBALY" // only for test
)

type koord struct {
	X byte
	Y byte
}

func (k *koord) LessThen(other *koord) bool {
	if k.Y > other.Y {
		return false
	}
	if k.Y < other.Y {
		return true
	}
	if k.X < other.X {
		return true
	}
	return false
}

func (k *koord) EqualTo(other koord) bool {
	if k.X == other.X && k.Y == other.Y {
		return true
	}
	return false
}

var encryptMap map[byte]koord
var decryptMap map[koord]byte

func squareToMaps(square [][]byte) (map[byte]koord, map[koord]byte) {
	eMap := make(map[byte]koord)
	dMap := make(map[koord]byte)
	for x, col := range square {
		for y, v := range col {
			eMap[v] = koord{byte(x), byte(y)}
			dMap[koord{byte(x), byte(y)}] = v

		}
	}
	return eMap, dMap
}

func removeSpaceI(text string) string {
	var n string
	s := strings.ToUpper(text)
	for _, b := range []byte(s) {
		//use only ASCII Characters from A to Z
		if b < 'A' || b > 'Z' {
			continue
		}
		if b == 'J' {
			b = 'I'
		}
		n = n + string(b)
	}
	return n
}

func removeSpace(text string, square map[byte]koord) string {
	var n string
	//to UpperCase and then remove all Spaces an Characters witch are not in square
	s := strings.ReplaceAll(strings.ToUpper(text), " ", "")
	for _, b := range []byte(s) {
		_, ok := square[b]
		if ok {
			n = n + string(b)
		}
	}
	return n
}

func encrypt(text string, emap map[byte]koord, dmap map[koord]byte) string {
	text = removeSpace(text, emap)
	var row0, row1 []byte
	for _, b := range []byte(text) {
		xy := emap[b]
		row0 = append(row0, xy.X)
		row1 = append(row1, xy.Y)
	}
	row0 = append(row0, row1...)

	var s string
	for i := 0; i < len(row0); i += 2 {
		s = s + string(dmap[koord{row0[i], row0[i+1]}])
	}
	return s
}

func decrypt(text string, emap map[byte]koord, dmap map[koord]byte) string {
	text = removeSpace(text, emap)
	k := make([]koord, len(text))

	for i, b := range []byte(text) {
		k[i] = emap[b]
	}

	kl := make([]byte, len(k)*2)
	i := int(0)
	for _, ki := range k {
		kl[i] = ki.X
		kl[i+1] = ki.Y
		i += 2
	}
	l := len(kl) / 2
	k1 := kl[:l]
	k2 := kl[l:]
	var s string

	for i := 0; i < l; i++ {
		s = s + string(dmap[koord{k1[i], k2[i]}])
	}
	return s
}

func main() {

	encryptMap, decryptMap = squareToMaps(squareRosetta)
	fmt.Println("from Rosettacode")
	fmt.Println("original:\t", textRosetta)
	s := encrypt(textRosetta, encryptMap, decryptMap)
	fmt.Println("codiert:\t", s)
	s = decrypt(s, encryptMap, decryptMap)
	fmt.Println("and back:\t", s)

	fmt.Println("from Wikipedia")
	encryptMap, decryptMap = squareToMaps(squareWikipedia)
	fmt.Println("original:\t", textWikipedia)
	s = encrypt(textWikipedia, encryptMap, decryptMap)
	fmt.Println("codiert:\t", s)
	s = decrypt(s, encryptMap, decryptMap)
	fmt.Println("and back:\t", s)

	encryptMap, decryptMap = squareToMaps(squareWikipedia)
	fmt.Println("from Rosettacode long part")
	fmt.Println("original:\t", textTest)
	s = encrypt(textTest, encryptMap, decryptMap)
	fmt.Println("codiert:\t", s)
	// Wenn der Text eine ungerade Anzahl Buchstaben hat, funktioniert der Algorithmus nicht!!!
	s = decrypt(s, encryptMap, decryptMap)
	fmt.Println("and back:\t", s)

}
