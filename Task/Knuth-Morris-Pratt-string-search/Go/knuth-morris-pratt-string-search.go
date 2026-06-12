package main

import (
	"fmt"
)

// printIntSlice prints a slice of integers in the format [e1, e2, ...]
func printIntSlice(slice []int) {
	fmt.Print("[")
	// Alternative using strings.Join (less efficient for large slices due to conversions)
	// if len(slice) > 0 {
	//  strSlice := make([]string, len(slice))
	//  for i, v := range slice {
	//      strSlice[i] = fmt.Sprint(v)
	//  }
	//  fmt.Print(strings.Join(strSlice, ", "))
	// }

	// More direct loop approach (similar to C++)
	for i, val := range slice {
		fmt.Print(val)
		if i < len(slice)-1 {
			fmt.Print(", ")
		}
	}
	fmt.Println("]")
}

// constructLPS builds the Longest Proper Prefix Suffix (LPS) array for KMP
func constructLPS(pattern string) []int {
	patternLen := len(pattern)
	if patternLen == 0 {
		return []int{}
	}
	// Initialize LPS array with zeros
	lps := make([]int, patternLen)
	length := 0 // Length of the previous longest prefix suffix
	patternIndex := 1

	// lps[0] is always 0, so we start from index 1
	for patternIndex < patternLen {
		// In Go, string indexing accesses bytes, which is what KMP needs here
		if pattern[patternIndex] == pattern[length] {
			length++
			lps[patternIndex] = length
			patternIndex++
		} else {
			// This is tricky. Consider the example.
			// AAACAAAA and i = 7. The idea is similar
			// to search step
			if length != 0 {
				length = lps[length-1]
				// Also, note that we do not increment patternIndex here
			} else {
				lps[patternIndex] = 0
				patternIndex++
			}
		}
	}
	return lps
}

// kmpSearch implements the KMP string searching algorithm
// Returns a slice of 0-based start indices where the pattern is found
func kmpSearch(pattern, text string) []int {
	var result []int // Initialize an empty slice for results
	patternLen := len(pattern)
	textLen := len(text)

	if patternLen == 0 || textLen == 0 || patternLen > textLen {
		return result // No matches possible
	}

	lps := constructLPS(pattern)

	textIndex := 0    // index for text
	patternIndex := 0 // index for pattern

	for textIndex < textLen {
		if pattern[patternIndex] == text[textIndex] {
			patternIndex++
			textIndex++

			if patternIndex == patternLen {
				// Match found, record start index
				// Use append to add the index to the result slice
				result = append(result, textIndex-patternIndex)
				// Move patternIndex back using LPS array to find next potential match
				patternIndex = lps[patternIndex-1]
			}
		} else {
			// Mismatch after patternIndex matches
			if patternIndex != 0 {
				// Don't match lps[0..lps[patternIndex-1]] characters,
				// they will match anyway
				patternIndex = lps[patternIndex-1]
			} else {
				// patternIndex is 0, just move to the next character in text
				textIndex++
			}
		}
	}

	return result
}

func main() {
	texts := []string{
		"GCTAGCTCTACGAGTCTA",
		"GGCTATAATGCGTA",
		"there would have been a time for such a word",
		"needle need noodle needle",
		"InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
		"Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk.",
	}

	patterns := []string{"TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa"}

	for i, text := range texts {
		fmt.Printf("Text%d = %s\n", i+1, text)
	}
	fmt.Println() // Equivalent to std::cout << std::endl;

	for i, pattern := range patterns {
		// Translate the text index logic: j = ( i < 5 ) ? i : i - 1;
		var textIndex int
		if i < 5 {
			textIndex = i
		} else {
			textIndex = i - 1
		}

        // Basic bounds check (good practice)
		if textIndex < 0 || textIndex >= len(texts) {
            fmt.Printf("Warning: Calculated text index %d is out of bounds for pattern '%s'\n", textIndex, pattern)
            continue // Skip to next pattern
        }

		result := kmpSearch(pattern, texts[textIndex])
		fmt.Printf("Found '%s' in 'Text%d' at indices ", pattern, textIndex+1)
		printIntSlice(result)
	}
}
