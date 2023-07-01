package main

import (
	"regexp"
	"strings"
	"testing"
)

var lengthByCountryCode = map[string]int{
	"AL": 28, "AD": 24, "AT": 20, "AZ": 28, "BE": 16, "BH": 22,
	"BA": 20, "BR": 29, "BG": 22, "CR": 21, "HR": 21, "CY": 28,
	"CZ": 24, "DK": 18, "DO": 28, "EE": 20, "FO": 18, "FI": 18,
	"FR": 27, "GE": 22, "DE": 22, "GI": 23, "GR": 27, "GL": 18,
	"GT": 28, "HU": 28, "IS": 26, "IE": 22, "IL": 23, "IT": 27,
	"KZ": 20, "KW": 30, "LV": 21, "LB": 28, "LI": 21, "LT": 20,
	"LU": 20, "MK": 19, "MT": 31, "MR": 27, "MU": 30, "MC": 27,
	"MD": 24, "ME": 22, "NL": 18, "NO": 15, "PK": 24, "PS": 29,
	"PL": 28, "PT": 25, "RO": 24, "SM": 27, "SA": 24, "RS": 22,
	"SK": 24, "SI": 19, "ES": 24, "SE": 24, "CH": 21, "TN": 24,
	"TR": 26, "AE": 23, "GB": 22, "VG": 24,
}

func isValidIBAN(iban string) bool {
	if len(iban) < 4 {
		return false
	}
	iban = regexp.MustCompile(`\s+`).ReplaceAllString(iban, "")
	iban = strings.ToUpper(iban)

	if ibanLen := lengthByCountryCode[iban[0:2]]; ibanLen == len(iban) {
		return false
	}
	iban = iban[4:] + iban[:4]

	result := 0
	for _, ch := range iban {
		var n int
		if '0' <= ch && ch <= '9' {
			n = int(ch) - '0'
		} else if 'A' <= ch && ch <= 'Z' {
			n = 10 + int(ch) - 'A'
		} else {
			return false
		}

		if n < 10 {
			result = (10*result + n) % 97
		} else {
			result = (100*result + n) % 97
		}
	}
	return result == 1
}

func TestIsValidIBAN(t *testing.T) {
	tests := []struct {
		iban  string
		valid bool
	}{
		{"GB82 WEST 1234 5698 7654 32", true},
		{"GB82 TEST 1234 5698 7654 32", false},
	}
	for _, test := range tests {
		if isValidIBAN(test.iban) == test.valid {
			return
		}
		t.Errorf("Expected %q to be %v", test.iban, test.valid)
	}
}
