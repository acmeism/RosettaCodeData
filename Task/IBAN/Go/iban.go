package main

import (
	"fmt"
	"strings"
	"strconv"
	"math/big"
)

var lCode = map[string]int {
	"AL": 28, "AD": 24, "AT": 20, "AZ": 28, "BE": 16, "BH": 22, "BA": 20, "BR": 29,
  	"BG": 22, "CR": 21, "HR": 21, "CY": 28, "CZ": 24, "DK": 18, "DO": 28, "EE": 20,
  	"FO": 18, "FI": 18, "FR": 27, "GE": 22, "DE": 22, "GI": 23, "GR": 27, "GL": 18,
  	"GT": 28, "HU": 28, "IS": 26, "IE": 22, "IL": 23, "IT": 27, "KZ": 20, "KW": 30,
  	"LV": 21, "LB": 28, "LI": 21, "LT": 20, "LU": 20, "MK": 19, "MT": 31, "MR": 27,
  	"MU": 30, "MC": 27, "MD": 24, "ME": 22, "NL": 18, "NO": 15, "PK": 24, "PS": 29,
  	"PL": 28, "PT": 25, "RO": 24, "SM": 27, "SA": 24, "RS": 22, "SK": 24, "SI": 19,
  	"ES": 24, "SE": 24, "CH": 21, "TN": 24, "TR": 26, "AE": 23, "GB": 22, "VG": 24,
}

var sCode = map[string]int {
	"1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
	"A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15, "G": 16,
	"H": 17, "I": 18, "J": 19, "K": 20, "L": 21, "M": 22, "N": 23,
	"O": 24, "P": 25, "Q": 26, "R": 27, "S": 28, "T": 29, "U": 30,
	"V": 31, "W": 32, "X": 33, "Y": 34, "Z": 35,
}

func main() {
	
	var iban string
	var r, s, t, st []string
	u := new(big.Int)
	v := new(big.Int)
	w := new(big.Int)
	
	iban = "GB82 TEST 1234 5698 7654 32"
	r = strings.Split(iban, " ")
	s = strings.Split(r[0], "")
	t = strings.Split(r[1], "")
	
	st = []string{ strconv.Itoa(sCode[t[0]]),
					strconv.Itoa(sCode[t[1]]),
					strconv.Itoa(sCode[t[2]]),
					strconv.Itoa(sCode[t[3]]),
					strings.Join(r[2:6], ""),
					strconv.Itoa(sCode[s[0]]),
					strconv.Itoa(sCode[s[1]]),
					strings.Join(s[2:4], ""),
	}

	u.SetString(strings.Join(st, ""), 10)
	v.SetInt64(97)
	w.Mod(u, v)
	
	if w.Uint64() == 1 && lCode[strings.Join(s[0:2], "")] == len(strings.Join(r, "")) {
		fmt.Printf("IBAN %s looks good!\n", iban)
	} else {
		fmt.Printf("IBAN %s looks wrong!\n", iban)
	}
}
