package main

import (
	"fmt"
	"strings"
	"unicode"
)

func snakeCaseToCamelCase(word string, sep rune) string {
	var sb strings.Builder

	wordRunes := []rune(strings.TrimSpace(word))
	wordLen := len(wordRunes)

	for i := 0; i < wordLen; i++ {
		c := wordRunes[i]

		if c == sep {
			if i+1 < wordLen && wordRunes[i+1] != sep {
				sb.WriteRune(unicode.ToUpper(wordRunes[i+1]))
				i++
			}
		} else {
			if i == 0 {
				c = unicode.ToLower(c)
			}
			sb.WriteRune(c)
		}
	}

	return sb.String()
}

func camelCaseToSnakeCase(word string, sep rune) string {
	word = strings.TrimSpace(word)
	var sb strings.Builder
	var lastRune rune

	for i, c := range word {
		if i != 0 && unicode.IsUpper(c) {
			if lastRune != sep {
				sb.WriteRune(sep)
			}
		}
		sb.WriteRune(unicode.ToLower(c))
		lastRune = c
	}

	return sb.String()
}

func main() {
	words := []string{
		"snakeCase",
		"snake_case",
		"variable_10_case",
		"variable10Case",
		"ɛrgo rE tHis",
		"hurry-up-joe!",
		"c://my-docs/happy_Flag-Day/12.doc",
		"  spaces  ",
	}

	fmt.Print("snake_case to camelCase:\n\n")

	for _, word := range words {
		fmt.Println(word, "=>", snakeCaseToCamelCase(word, '_'))
	}

	fmt.Println()
	fmt.Print("kebab-case to camelCase:\n\n")

	for _, word := range words {
		fmt.Println(word, "=>", snakeCaseToCamelCase(word, '-'))
	}

	fmt.Println()
	fmt.Print("space case to camelCase:\n\n")

	for _, word := range words {
		fmt.Println(word, "=>", snakeCaseToCamelCase(word, ' '))
	}

	fmt.Println()
	fmt.Print("camelCase to snake_case:\n\n")

	for _, word := range words {
		fmt.Println(word, "=>", camelCaseToSnakeCase(word, '_'))
	}

	fmt.Println()
	fmt.Print("camelCase to kebab-case:\n\n")

	for _, word := range words {
		fmt.Println(word, "=>", camelCaseToSnakeCase(word, '-'))
	}

	fmt.Println()
	fmt.Print("camelCase to space case:\n\n")

	for _, word := range words {
		fmt.Println(word, "=>", camelCaseToSnakeCase(word, ' '))
	}
}
