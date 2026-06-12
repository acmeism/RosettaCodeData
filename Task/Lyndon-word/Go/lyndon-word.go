package main

import (
	"fmt"
	"strings"
)

func main() {
	alphabet := []string{"0", "1"}
	word := alphabet[0]
	for word != "" {
		fmt.Println(word)
		word = nextWord(5, word, alphabet)
	}
}

// Using the Duval (1988) algorithm
func nextWord(maxLength int, word string, alphabet []string) string {
	// Step 1: Repeat the word and truncate
	nextWord := word
	for len(nextWord) < maxLength {
		nextWord += word
	}
	nextWord = nextWord[:maxLength]

	// Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
	alphabetLastSymbol := alphabet[len(alphabet)-1]
	for strings.HasSuffix(nextWord, alphabetLastSymbol) {
		nextWord = nextWord[:len(nextWord)-1]
	}

	// Step 3: Replace the last symbol of the next word by its successor in the alphabet
	if nextWord != "" {
		wordLastSymbol := nextWord[len(nextWord)-1:]
		var index int
		for i, s := range alphabet {
			if s == wordLastSymbol {
				index = i + 1
				break
			}
		}
		nextWord = nextWord[:len(nextWord)-1] + alphabet[index]
	}
	return nextWord
}
