package main

import (
	"bufio"
	"cmp"
	"fmt"
	"log"
	"os"
	"slices"
	"strings"
	"unicode/utf8"
)

func main() {
	words := readUniqueWords("words.txt", 6)
	anadromes := getAnadromes(words)
	lefts := sortedKeys(anadromes)
	for _, left := range lefts {
		right := anadromes[left]
		fmt.Printf("%9s ↔ %s\n", left, right)
	}
}

func readUniqueWords(filename string, minLen int) map[string]struct{} {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	words := map[string]struct{}{}
	for scanner.Scan() {
		word := scanner.Text()
		if utf8.RuneCountInString(word) > minLen {
			word = strings.ToLower(word)
			words[word] = struct{}{}
		}
	}
	return words
}

func getAnadromes(words map[string]struct{}) map[string]string {
	seen := map[string]struct{}{}
	anadromes := map[string]string{}
	for _, word := range sortedKeys(words) {
		rword := reverse(word)
		if rword != word {
			if _, found := words[rword]; found {
				if _, found := seen[word]; !found {
					if _, found := seen[rword]; !found {
						anadromes[word] = rword
						seen[word] = struct{}{}
						seen[rword] = struct{}{}
					}
				}
			}
		}
	}
	return anadromes
}

func sortedKeys[K cmp.Ordered, V any](m map[K]V) []K {
	keys := make([]K, 0, len(m))
	for key := range m {
		keys = append(keys, key)
	}
	slices.Sort(keys)
	return keys
}

func reverse(text string) string {
	runes := []rune(text)
	slices.Reverse(runes)
	return string(runes)
}
