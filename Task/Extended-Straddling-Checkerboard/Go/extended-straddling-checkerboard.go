package main

import (
	"fmt"
	"strings"
)

var WDICT = map[string]string{
	"CODE": "κ",
	"ACK":  "α",
	"REQ":  "ρ",
	"MSG":  "μ",
	"RV":   "ν",
	"GRID": "γ",
	"SEND": "σ",
	"SUPP": "π",
}

// Reversed WDICT for reverse lookup on decode
var SDICT = map[string]string{}

// CT37w at https://www.ciphermachinesandcryptology.com/en/table.htm
var CT37w = [][]string{
	{"", "A", "E", "I", "N", "O", "T", "κ", "", "", ""},
	{"7", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M"},
	{"8", "P", "Q", "R", "S", "U", "V", "W", "X", "Y", "Z"},
	{"9", " ", ".", "α", "ρ", "μ", "ν", "γ", "σ", "π", "/"},
}

// Modified CT37w: web site CT37w, but exchange '/' (FIG) char and 'π'
// to help differentiate the '999' encoding for a '9' from a terminator code
var CT37w_mod = [][]string{
	{"", "A", "E", "I", "N", "O", "T", "κ", "", "", ""},
	{"7", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M"},
	{"8", "P", "Q", "R", "S", "U", "V", "W", "X", "Y", "Z"},
	{"9", " ", ".", "α", "ρ", "μ", "ν", "γ", "σ", "/", "π"},
}

func init() {
	// Initialize SDICT by reversing WDICT
	for k, v := range WDICT {
		SDICT[v] = k
	}
}

func xcb_encode(message string, table [][]string, code string, wdict map[string]string) string {
	encoded := []string{}
	numericmode, codemode := false, false
	codemodecount := 0
	var nchangemode string
	var digit_repeats int

	if table[len(table)-1][len(table[len(table)-1])-1] == "/" {
		nchangemode = "99"
		digit_repeats = 3
	} else {
		nchangemode = "98"
		digit_repeats = 2
	}

	// Replace terms found in dictionary with a single char symbol that is in the table
	s := strings.ToUpper(message)
	for k, v := range wdict {
		s = strings.ReplaceAll(s, k, v)
	}

	for _, c := range s {
		char := string(c)
		if char >= "0" && char <= "9" {
			if codemode { // codemode symbols are preceded by the CODE digit '6' then as-is
				encoded = append(encoded, char)
				codemodecount++
				if codemodecount >= 3 {
					codemode = false
				}
			} else {
				if !numericmode {
					numericmode = true
					encoded = append(encoded, nchangemode) // FIG
				}
				encoded = append(encoded, strings.Repeat(char, digit_repeats))
			}
		} else {
			codemode = false
			if numericmode {
				// end numericmode with the FIG numeric code for '/' (98)
				encoded = append(encoded, nchangemode)
				numericmode = false
			}

			if char == code {
				codemode = true
				codemodecount = 0
			}

			for _, row := range table {
				for colIndex, tableChar := range row {
					if char == tableChar {
						encoded = append(encoded, row[0]+fmt.Sprintf("%d", colIndex-1))
						break
					}
				}
			}
		}
	}

	return strings.Join(encoded, "")
}

func xcb_decode(s string, table [][]string, code string, sdict map[string]string) string {
	prefixes := []string{}
	for _, row := range table {
		if row[0] != "" {
			prefixes = append(prefixes, row[0])
		}
	}

	// Sort prefixes in descending order
	for i := 0; i < len(prefixes); i++ {
		for j := i + 1; j < len(prefixes); j++ {
			if prefixes[i] < prefixes[j] {
				prefixes[i], prefixes[j] = prefixes[j], prefixes[i]
			}
		}
	}

	pos, numericmode, codemode := 0, false, false
	decoded := []string{}
	var nchangemode string
	var digit_repeats int

	if table[len(table)-1][len(table[len(table)-1])-1] == "/" {
		nchangemode = "99"
		digit_repeats = 3
	} else {
		nchangemode = "98"
		digit_repeats = 2
	}

	numbers := make(map[string]string)
	for _, c := range "0123456789" {
		numbers[strings.Repeat(string(c), digit_repeats)] = string(c)
	}

	for pos < len(s) {
		if numericmode {
			if pos+digit_repeats <= len(s) {
				numSeq := s[pos : pos+digit_repeats]
				if val, ok := numbers[numSeq]; ok {
					decoded = append(decoded, val)
					pos += digit_repeats - 1
				} else if pos+2 <= len(s) && s[pos:pos+2] == nchangemode {
					numericmode = false
					pos += 1
				} else if len(decoded) > 0 && decoded[len(decoded)-1] == "9" { // error, so backtrack if last was 9
					decoded = decoded[:len(decoded)-1]
					numericmode = false
					pos -= digit_repeats - 1
				}
			}
		} else if codemode {
			if pos+3 <= len(s) {
				codeSeq := s[pos : pos+3]
				isNumeric := true
				for _, c := range codeSeq {
					if c < '0' || c > '9' {
						isNumeric = false
						break
					}
				}
				if isNumeric {
					decoded = append(decoded, codeSeq)
					pos += 2
				}
			}
			codemode = false
		} else if pos+2 <= len(s) && s[pos:pos+2] == nchangemode {
			numericmode = !numericmode
			pos += 1
		} else {
			found := false
			for _, p := range prefixes {
				if pos+len(p) <= len(s) && s[pos:pos+len(p)] == p {
					n := len(p)
					if pos+n < len(s) {
						var row int
						for i, r := range table {
							if r[0] == p {
								row = i
								break
							}
						}
						colIdx, _ := fmt.Sscanf(string(s[pos+n]), "%d")
						colIdx += 1
						if colIdx < len(table[row]) {
							c := table[row][colIdx]
							decoded = append(decoded, c)
							if c == code {
								codemode = true
							}
						}
					}
					pos += n
					found = true
					break
				}
			}
			if !found {
				pos += 1
				continue
			}
		}
		pos += 1
	}

	result := strings.Join(decoded, "")
	for k, v := range sdict {
		result = strings.ReplaceAll(result, k, v)
	}
	return result
}

func main() {
	message := "Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March"
	fmt.Println(message)
	encoded := xcb_encode(message, CT37w, "κ", WDICT)
	fmt.Println("Encoded: ", encoded)
	fmt.Println("Decoded: ", xcb_decode(encoded, CT37w, "κ", SDICT))
	encoded = xcb_encode(message, CT37w_mod, "κ", WDICT)
	fmt.Println("Encoded: ", encoded)
	fmt.Println("Decoded: ", xcb_decode(encoded, CT37w_mod, "κ", SDICT))
}
