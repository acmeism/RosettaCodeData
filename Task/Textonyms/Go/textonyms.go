package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
	"unicode"
)

func main() {
	log.SetFlags(0)
	log.SetPrefix("textonyms: ")

	wordlist := flag.String("wordlist", "wordlist", "file containing the list of words to check")
	flag.Parse()
	if flag.NArg() != 0 {
		flag.Usage()
		os.Exit(2)
	}

	t := NewTextonym(phoneMap)
	_, err := ReadFromFile(t, *wordlist)
	if err != nil {
		log.Fatal(err)
	}
	t.Report(os.Stdout, *wordlist)
}

// phoneMap is the digit to letter mapping of a typical phone.
var phoneMap = map[byte][]rune{
	'2': []rune("ABC"),
	'3': []rune("DEF"),
	'4': []rune("GHI"),
	'5': []rune("JKL"),
	'6': []rune("MNO"),
	'7': []rune("PQRS"),
	'8': []rune("TUV"),
	'9': []rune("WXYZ"),
}

// ReadFromFile is a generic convience function that allows the use of a
// filename with an io.ReaderFrom and handles errors related to open and
// closing the file.
func ReadFromFile(r io.ReaderFrom, filename string) (int64, error) {
	f, err := os.Open(filename)
	if err != nil {
		return 0, err
	}
	n, err := r.ReadFrom(f)
	if cerr := f.Close(); err == nil && cerr != nil {
		err = cerr
	}
	return n, err
}

type Textonym struct {
	numberMap map[string][]string // map numeric string into words
	letterMap map[rune]byte       // map letter to digit
	count     int                 // total number of words in numberMap
	textonyms int                 // number of numeric strings with >1 words
}

func NewTextonym(dm map[byte][]rune) *Textonym {
	lm := make(map[rune]byte, 26)
	for d, ll := range dm {
		for _, l := range ll {
			lm[l] = d
		}
	}
	return &Textonym{letterMap: lm}
}

func (t *Textonym) ReadFrom(r io.Reader) (n int64, err error) {
	t.numberMap = make(map[string][]string)
	buf := make([]byte, 0, 32)
	sc := bufio.NewScanner(r)
	sc.Split(bufio.ScanWords)
scan:
	for sc.Scan() {
		buf = buf[:0]
		word := sc.Text()

		// XXX we only bother approximating the number of bytes
		// consumed. This isn't used in the calling code and was
		// only included to match the io.ReaderFrom interface.
		n += int64(len(word)) + 1

		for _, r := range word {
			d, ok := t.letterMap[unicode.ToUpper(r)]
			if !ok {
				//log.Printf("ignoring %q\n", word)
				continue scan
			}
			buf = append(buf, d)
		}
		//log.Printf("scanned %q\n", word)
		num := string(buf)
		t.numberMap[num] = append(t.numberMap[num], word)
		t.count++
		if len(t.numberMap[num]) == 2 {
			t.textonyms++
		}
		//log.Printf("%q → %v\t→ %v\n", word, num, t.numberMap[num])
	}
	return n, sc.Err()
}

func (t *Textonym) Most() (most int, subset map[string][]string) {
	for k, v := range t.numberMap {
		switch {
		case len(v) > most:
			subset = make(map[string][]string)
			most = len(v)
			fallthrough
		case len(v) == most:
			subset[k] = v
		}
	}
	return most, subset
}

func (t *Textonym) Report(w io.Writer, name string) {
	// Could be fancy and use text/template package but fmt is sufficient
	fmt.Fprintf(w, `
There are %v words in %q which can be represented by the digit key mapping.
They require %v digit combinations to represent them.
%v digit combinations represent Textonyms.
`,
		t.count, name, len(t.numberMap), t.textonyms)

	n, sub := t.Most()
	fmt.Fprintln(w, "\nThe numbers mapping to the most words map to",
		n, "words each:")
	for k, v := range sub {
		fmt.Fprintln(w, "\t", k, "maps to:", strings.Join(v, ", "))
	}
}
