package main

import (
	"container/list"
	"fmt"
	"strings"
	"unicode"
)

func isVowel(c rune) bool {
	loweredChar := unicode.ToLower(c)
	return loweredChar == 'a' || loweredChar == 'e' || loweredChar == 'i' || loweredChar == 'o' || loweredChar == 'u'
}

func toEnd(word string) string {
	new := list.New()

	toBack := true
	var normalHead *list.Element = nil

	for _, c := range word {
		if toBack && isVowel(c) {
			toBack = false
		}

		if normalHead == nil && !toBack {
			normalHead = new.PushFront(c)
		} else if normalHead != nil {
			normalHead = new.InsertAfter(c, normalHead)
		} else {
			new.PushBack(c)
		}
	}

	var sb strings.Builder

	for node := new.Front(); node != nil; node = node.Next() {
		sb.WriteRune(node.Value.(rune))
	}

	sb.WriteString("ay")
	return sb.String()
}

func toPigLatin(sentence string) string {
	var sb strings.Builder
	items := strings.Split(sentence, " ")
	for i, word := range items {
		if len(word) == 0 {
			continue
		}
		sb.WriteString(toEnd(word))
		if i != len(items)-1 {
			sb.WriteString(" ")
		}
	}

	return sb.String()
}

func main() {
	sentences := []string{
		"hello world",
		"pig latin",
		"rosetta code",
		"the quick brown fox jumps over the lazy dog",
		"by the way",
	}

	for _, sentence := range sentences {
		fmt.Println(toPigLatin(sentence))
	}
}
