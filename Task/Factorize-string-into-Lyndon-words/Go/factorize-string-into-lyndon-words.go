package main

import (
	"fmt"
	"strings"
)

func main() {
	// Create a 128 character Thue-Morse word
	thueMorse := "0"
	for i := 0; i < 7; i++ {
		thueMorseCopy := thueMorse
		thueMorse = strings.ReplaceAll(thueMorse, "0", "a")
		thueMorse = strings.ReplaceAll(thueMorse, "1", "0")
		thueMorse = strings.ReplaceAll(thueMorse, "a", "1")
		thueMorse = thueMorseCopy + thueMorse
	}

	fmt.Println("The Thue-Morse word to be factorised:")
	fmt.Println(thueMorse)

	fmt.Println()
	fmt.Println("The factors are:")
	for _, factor := range duval(thueMorse) {
		fmt.Println(factor)
	}
}

// Duval's algorithm
func duval(text string) []string {
	var factorisation []string
	i := 0

	for i < len(text) {
		j := i + 1
		k := i

		for j < len(text) && text[k] <= text[j] {
			if text[k] < text[j] {
				k = i
			} else {
				k++
			}

			j++
		}

		for i <= k {
			factorisation = append(factorisation, text[i:i+j-k])
			i += j - k
		}
	}

	return factorisation
}
