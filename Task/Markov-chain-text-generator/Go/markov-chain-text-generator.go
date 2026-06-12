package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"math/rand"
	"os"
	"strings"
	"time"
	"unicode"
	"unicode/utf8"
)

func main() {
	log.SetFlags(0)
	log.SetPrefix("markov: ")
	input := flag.String("in", "alice_oz.txt", "input file")
	n := flag.Int("n", 2, "number of words to use as prefix")
	runs := flag.Int("runs", 1, "number of runs to generate")
	wordsPerRun := flag.Int("words", 300, "number of words per run")
	startOnCapital := flag.Bool("capital", false, "start output with a capitalized prefix")
	stopAtSentence := flag.Bool("sentence", false, "end output at a sentence ending punctuation mark (after n words)")
	flag.Parse()

	rand.Seed(time.Now().UnixNano())

	m, err := NewMarkovFromFile(*input, *n)
	if err != nil {
		log.Fatal(err)
	}

	for i := 0; i < *runs; i++ {
		err = m.Output(os.Stdout, *wordsPerRun, *startOnCapital, *stopAtSentence)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println()
	}
}

// We'd like to use a map of []string -> []string (i.e. list of prefix
// words -> list of possible next words) but Go doesn't allow slices to be
// map keys.
//
// We could use arrays, e.g. map of [2]string -> []string, but array lengths
// are fixed at compile time. To work around that we could set a maximum value
// for n, say 8 or 16, and waste the extra array slots for smaller n.
//
// Or we could make the suffix map key just be the full prefix string. Then
// to get the words within the prefix we could either have a separate map
// (i.e. map of string -> []string) for the full prefix string -> the list
// of the prefix words. Or we could use strings.Fields() and strings.Join() to
// go back and forth (trading more runtime for less memory use).

// Markov is a Markov chain text generator.
type Markov struct {
	n           int
	capitalized int // number of suffix keys that start capitalized
	suffix      map[string][]string
}

// NewMarkovFromFile initializes the Markov text generator
// with window `n` from the contents of `filename`.
func NewMarkovFromFile(filename string, n int) (*Markov, error) {
	f, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer f.Close() // nolint: errcheck
	return NewMarkov(f, n)
}

// NewMarkov initializes the Markov text generator
// with window `n` from the contents of `r`.
func NewMarkov(r io.Reader, n int) (*Markov, error) {
	m := &Markov{
		n:      n,
		suffix: make(map[string][]string),
	}
	sc := bufio.NewScanner(r)
	sc.Split(bufio.ScanWords)
	window := make([]string, 0, n)
	for sc.Scan() {
		word := sc.Text()
		if len(window) > 0 {
			prefix := strings.Join(window, " ")
			m.suffix[prefix] = append(m.suffix[prefix], word)
			//log.Printf("%20q -> %q", prefix, m.suffix[prefix])
			if isCapitalized(prefix) {
				m.capitalized++
			}
		}
		window = appendMax(n, window, word)
	}
	if err := sc.Err(); err != nil {
		return nil, err
	}
	return m, nil
}

// Output writes generated text of approximately `n` words to `w`.
// If `startCapital` is true it picks a starting prefix that is capitalized.
// If `stopSentence` is true it continues after `n` words until it finds
// a suffix ending with sentence ending punctuation ('.', '?', or '!').
func (m *Markov) Output(w io.Writer, n int, startCapital, stopSentence bool) error {
	// Use a bufio.Writer both for buffering and for simplified
	// error handling (it remembers any error and turns all future
	// writes/flushes into NOPs returning the same error).
	bw := bufio.NewWriter(w)

	var i int
	if startCapital {
		i = rand.Intn(m.capitalized)
	} else {
		i = rand.Intn(len(m.suffix))
	}
	var prefix string
	for prefix = range m.suffix {
		if startCapital && !isCapitalized(prefix) {
			continue
		}
		if i == 0 {
			break
		}
		i--
	}

	bw.WriteString(prefix) // nolint: errcheck
	prefixWords := strings.Fields(prefix)
	n -= len(prefixWords)

	for {
		suffixChoices := m.suffix[prefix]
		if len(suffixChoices) == 0 {
			break
		}
		i = rand.Intn(len(suffixChoices))
		suffix := suffixChoices[i]
		//log.Printf("prefix: %q, suffix: %q (from %q)", prefixWords, suffix, suffixChoices)
		bw.WriteByte(' ') // nolint: errcheck
		if _, err := bw.WriteString(suffix); err != nil {
			break
		}
		n--
		if n < 0 && (!stopSentence || isSentenceEnd(suffix)) {
			break
		}

		prefixWords = appendMax(m.n, prefixWords, suffix)
		prefix = strings.Join(prefixWords, " ")
	}
	return bw.Flush()
}

func isCapitalized(s string) bool {
	// We can't just look at s[0], which is the first *byte*,
	// if we want to support arbitrary Unicode input.
	// This still doesn't support combining runes :(.
	r, _ := utf8.DecodeRuneInString(s)
	return unicode.IsUpper(r)
}

func isSentenceEnd(s string) bool {
	r, _ := utf8.DecodeLastRuneInString(s)
	// Unfortunately, Unicode doesn't seem to provide
	// a test for sentence ending punctution :(.
	//return unicode.IsPunct(r)
	return r == '.' || r == '?' || r == '!'
}

func appendMax(max int, slice []string, value string) []string {
	// Often FIFO queues in Go are implemented via:
	//     fifo = append(fifo, newValues...)
	// and:
	//     fifo = fifo[numberOfValuesToRemove:]
	//
	// However, the append will periodically reallocate and copy. Since
	// we're dealing with a small number (usually two) of strings and we
	// only need to append a single new string it's better to (almost)
	// never reallocate the slice and just copy n-1 strings (which only
	// copies n-1 pointers, not the entire string contents) every time.
	if len(slice)+1 > max {
		n := copy(slice, slice[1:])
		slice = slice[:n]
	}
	return append(slice, value)
}
