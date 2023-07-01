package main

import (
	"fmt"
	"unicode"
)

const (
	lcASCII = "abcdefghijklmnopqrstuvwxyz"
	ucASCII = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
)

func main() {
	fmt.Println("ASCII lower case:")
	fmt.Println(lcASCII)
	for l := 'a'; l <= 'z'; l++ {
		fmt.Print(string(l))
	}
	fmt.Println()

	fmt.Println("\nASCII upper case:")
	fmt.Println(ucASCII)
	for l := 'A'; l <= 'Z'; l++ {
		fmt.Print(string(l))
	}
	fmt.Println()

	fmt.Println("\nUnicode version " + unicode.Version)
	showRange16("Lower case 16-bit code points:", unicode.Lower.R16)
	showRange32("Lower case 32-bit code points:", unicode.Lower.R32)
	showRange16("Upper case 16-bit code points:", unicode.Upper.R16)
	showRange32("Upper case 32-bit code points:", unicode.Upper.R32)
}

func showRange16(hdr string, rList []unicode.Range16) {
	fmt.Print("\n", hdr, "\n")
	fmt.Printf("%d ranges:\n", len(rList))
	for _, rng := range rList {
		fmt.Printf("%U: ", rng.Lo)
		for r := rng.Lo; r <= rng.Hi; r += rng.Stride {
			fmt.Printf("%c", r)
		}
		fmt.Println()
	}
}

func showRange32(hdr string, rList []unicode.Range32) {
	fmt.Print("\n", hdr, "\n")
	fmt.Printf("%d ranges:\n", len(rList))
	for _, rng := range rList {
		fmt.Printf("%U: ", rng.Lo)
		for r := rng.Lo; r <= rng.Hi; r += rng.Stride {
			fmt.Printf("%c", r)
		}
		fmt.Println()
	}
}
