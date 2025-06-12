package main

import (
	"fmt"
	"strings"
)

func display(numbers []int32) {
	fmt.Print("[")
	for i, num := range numbers {
		if i > 0 {
			fmt.Print(", ")
		}
		fmt.Print(num)
	}
	fmt.Println("]")
}

func stringSearchSingle(haystack, needle string) int32 {
	index := strings.Index(haystack, needle)
	return int32(index)
}

func stringSearch(haystack, needle string) []int32 {
	var result []int32
	var start int64 = 0
	
	for start < int64(len(haystack)) {
		haystackReduced := haystack[start:]
		index := stringSearchSingle(haystackReduced, needle)
		
		if index >= 0 {
			result = append(result, int32(start)+index)
			start += int64(index) + int64(len(needle))
		} else {
			break
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
		"DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
		"Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk.",
	}

	patterns := []string{"TCTA", "TAATAAA", "word", "needle", "and", "alfalfa"}

	for i := 0; i < len(texts); i++ {
		fmt.Printf("text%d = %s\n", i+1, texts[i])
	}
	fmt.Println()

	for i := 0; i < len(texts); i++ {
		indexes := stringSearch(texts[i], patterns[i])
		fmt.Printf("Found \"%s\" in 'text%d' at indexes ", patterns[i], i+1)
		display(indexes)
	}
}
