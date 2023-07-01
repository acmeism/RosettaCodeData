package main

import (
	"crypto/rand"
	"math/big"
	"strings"
	"flag"
	"math"
        "fmt"
)

var lowercase = "abcdefghijklmnopqrstuvwxyz"
var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var numbers = "0123456789"
var signs = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"
var similar = "Il1O05S2Z"

func check(e error){
	if e != nil {
		panic(e)
	}
}

func randstr(length int, alphastr string) string{
	alphabet := []byte(alphastr)
	pass := make([]byte,length)
	for i := 0; i < length; i++ {
		bign, err := rand.Int(rand.Reader, big.NewInt(int64(len(alphabet))))
		check(err)
		n := bign.Int64()
		pass[i] = alphabet[n]
	}
	return string(pass)
}

func verify(pass string,checkUpper bool,checkLower bool, checkNumber bool, checkSign bool) bool{
	isValid := true
	if(checkUpper){
		isValid = isValid && strings.ContainsAny(pass,uppercase)
	}
	if(checkLower){
		isValid = isValid && strings.ContainsAny(pass,lowercase)
	}
	if(checkNumber){
		isValid = isValid && strings.ContainsAny(pass,numbers)
	}
	if(checkSign){
		isValid = isValid && strings.ContainsAny(pass,signs)
	}
	return isValid
}


func main() {
	passCount := flag.Int("pc", 6, "Number of passwords")
	passLength := flag.Int("pl", 10, "Passwordlength")
	useUpper := flag.Bool("upper", true, "Enables or disables uppercase letters")
	useLower := flag.Bool("lower", true, "Enables or disables lowercase letters")
	useSign := flag.Bool("sign", true, "Enables or disables signs")
	useNumbers := flag.Bool("number", true, "Enables or disables numbers")
	useSimilar := flag.Bool("similar", true,"Enables or disables visually similar characters")
	flag.Parse()

	passAlphabet := ""
	if *useUpper {
		passAlphabet += uppercase
	}
	if *useLower {
		passAlphabet += lowercase
	}
	if *useSign {
		passAlphabet += signs
	}
	if *useNumbers {
		passAlphabet += numbers
	}
	if !*useSimilar {
		for _, r := range similar{
			passAlphabet = strings.Replace(passAlphabet,string(r),"", 1)
		}
	}
	fmt.Printf("Generating passwords with an average entropy of %.1f bits \n", math.Log2(float64(len(passAlphabet))) * float64(*passLength))
	for i := 0; i < *passCount;i++{
		passFound := false
		pass := ""
		for(!passFound){
			pass = randstr(*passLength,passAlphabet)
			passFound = verify(pass,*useUpper,*useLower,*useNumbers,*useSign)
		}
		fmt.Println(pass)
	}
}
