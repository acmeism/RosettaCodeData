package main

import (
	"fmt"
	"sort"
	"strings"
)

func main() {
	text := strings.ToUpper("Live and let live")
	letterCounts := []int{2, 3, 4}
	
	for _, letterCount := range letterCounts {
		ngrams := findNgrams(text, letterCount)
		fmt.Printf("All %d-grams of %s and their frequencies:\n", letterCount, text)
		for _, entry := range ngrams {
			fmt.Printf("(\"%s\" : %d)\n", entry.Key, entry.Value)
		}
		fmt.Println()
	}
}

type Entry struct {
	Key   string
	Value int
}

func findNgrams(text string, letterCount int) []Entry {
	ngramMap := make(map[string]int)
	
	for i := 0; i <= len(text)-letterCount; i++ {
		ngram := text[i : i+letterCount]
		ngramMap[ngram]++
	}
	
	return sortMap(ngramMap)
}

func sortMap(m map[string]int) []Entry {
	entries := make([]Entry, 0, len(m))
	
	for k, v := range m {
		entries = append(entries, Entry{Key: k, Value: v})
	}
	
	sort.Slice(entries, func(i, j int) bool {
		if entries[i].Value != entries[j].Value {
			return entries[i].Value > entries[j].Value // Sort by frequency descending
		}
		return entries[i].Key < entries[j].Key // Sort by key ascending for ties
	})
	
	return entries
}
