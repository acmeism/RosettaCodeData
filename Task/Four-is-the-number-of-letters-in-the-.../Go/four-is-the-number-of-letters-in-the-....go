package main

import (
	"fmt"
	"strings"
	"unicode"
)

func main() {
	f := NewFourIsSeq()
	fmt.Print("The lengths of the first 201 words are:")
	for i := 1; i <= 201; i++ {
		if i%25 == 1 {
			fmt.Printf("\n%3d: ", i)
		}
		_, n := f.WordLen(i)
		fmt.Printf(" %2d", n)
	}
	fmt.Println()
	fmt.Println("Length of sentence so far:", f.TotalLength())
	/* For debugging:
	log.Println("sentence:", strings.Join(f.words, " "))
	for i, w := range f.words {
		log.Printf("%3d: %2d %q\n", i, countLetters(w), w)
	}
	log.Println(f.WordLen(2202))
	log.Println("len(f.words):", len(f.words))
	log.Println("sentence:", strings.Join(f.words, " "))
	*/
	for i := 1000; i <= 1e7; i *= 10 {
		w, n := f.WordLen(i)
		fmt.Printf("Word %8d is %q, with %d letters.", i, w, n)
		fmt.Println("  Length of sentence so far:", f.TotalLength())
	}
}

type FourIsSeq struct {
	i     int      // index of last word processed
	words []string // strings.Join(words," ") gives the sentence so far
}

func NewFourIsSeq() *FourIsSeq {
	return &FourIsSeq{
		//words: strings.Fields("Four is the number of letters in the first word of this sentence,"),
		words: []string{
			"Four", "is", "the", "number",
			"of", "letters", "in", "the",
			"first", "word", "of", "this", "sentence,",
		},
	}
}

// WordLen returns the w'th word and its length (only counting letters).
func (f *FourIsSeq) WordLen(w int) (string, int) {
	for len(f.words) < w {
		f.i++
		n := countLetters(f.words[f.i])
		ns := say(int64(n))
		os := sayOrdinal(int64(f.i+1)) + ","
		// append something like: "two in the second,"
		f.words = append(f.words, strings.Fields(ns)...)
		f.words = append(f.words, "in", "the")
		f.words = append(f.words, strings.Fields(os)...)
	}
	word := f.words[w-1]
	return word, countLetters(word)
}

// TotalLength returns the total number of characters (including blanks,
// commas, and punctuation) of the sentence so far constructed.
func (f FourIsSeq) TotalLength() int {
	cnt := 0
	for _, w := range f.words {
		cnt += len(w) + 1
	}
	return cnt - 1
}

func countLetters(s string) int {
	cnt := 0
	for _, r := range s {
		if unicode.IsLetter(r) {
			cnt++
		}
	}
	return cnt
}

// ...
// the contents of
// https://rosettacode.org/wiki/Spelling_of_ordinal_numbers#Go
// omitted from this listing
// ...
