package main

import "fmt"

func Ext(path string) string {
	for i := len(path) - 1; i >= 0; i-- {
		c := path[i]
		switch {
		case c == '.':
			return path[i:]
		case '0' <= c && c <= '9':
		case 'A' <= c && c <= 'Z':
		case 'a' <= c && c <= 'z':
		default:
			return ""
		}
	}
	return ""
}

func main() {
	type testcase struct {
		input  string
		output string
	}

	tests := []testcase{
		{"http://example.com/download.tar.gz", ".gz"},
		{"CharacterModel.3DS", ".3DS"},
		{".desktop", ".desktop"},
		{"document", ""},
		{"document.txt_backup", ""},
		{"/etc/pam.d/login", ""},
	}

	for _, testcase := range tests {
		ext := Ext(testcase.input)
		if ext != testcase.output {
			panic(fmt.Sprintf("expected %q for %q, got %q",
				testcase.output, testcase.input, ext))
		}
	}
}
