package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func csvTsv(str string) (string, string) {
	p := strings.Split(str, ",")
	
	for i, f := range p {
		count := strings.Count(f, "\"")
		if count > 1 {
			p[i] = strings.ReplaceAll(strings.Trim(f, " \""), "\"\"", "\"")
		} else if f == "\"" {
			p[i] = ""
		}
	}
	
	t := strings.Join(p, "<TAB>")
	
	s := str
	s = strings.ReplaceAll(s, "\\", "\\\\")
	s = strings.ReplaceAll(s, "\t", "\\t")
	s = strings.ReplaceAll(s, "\000", "\\0")
	s = strings.ReplaceAll(s, "\n", "\\n")
	s = strings.ReplaceAll(s, "\r", "\\r")
	
	t = strings.ReplaceAll(t, "\\", "\\\\")
	t = strings.ReplaceAll(t, "\t", "\\t")
	t = strings.ReplaceAll(t, "\000", "\\0")
	t = strings.ReplaceAll(t, "\n", "\\n")
	t = strings.ReplaceAll(t, "\r", "\\r")
	
	return s, t
}

func main() {
	const testfile = "test.tmp"
	
	content := `a,"b"
"a","b""c"

,a
a,"
 a , "b"
"12",34
a\tb, TAB
a\\tb
a\\n\\rb
a\0b, NUL
a\rb, RETURN
a\\b`
	
	err := os.WriteFile(testfile, []byte(content), 0644)
	if err != nil {
		panic(err)
	}
	
	file, err := os.Open(testfile)
	if err != nil {
		panic(err)
	}
	defer file.Close()
	
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		testString := scanner.Text()
		csv, tsv := csvTsv(testString)
		// Using fmt.Sprintf to pad the string to the right
		fmt.Printf("%12s => %s\n", csv, tsv)
	}
	
	if err := scanner.Err(); err != nil {
		panic(err)
	}
}
