package main

import (
	"fmt"
	"strconv"
	"strings"
)

func vectorToString(vec []int32) string {
	result := "["
	for i, v := range vec {
		result += strconv.FormatInt(int64(v), 10)
		if i < len(vec)-1 {
			result += ", "
		}
	}
	return result + "]"
}

func jaccardIndex(a []int32, b []int32) float64 {
	// Create set from array a
	setA := make(map[int32]bool)
	for _, val := range a {
		setA[val] = true
	}

	// Count intersection
	intersectionCount := 0
	for _, val := range b {
		if setA[val] {
			intersectionCount++
		}
	}

	// Create union set
	unionSet := make(map[int32]bool)
	for _, val := range a {
		unionSet[val] = true
	}
	for _, val := range b {
		unionSet[val] = true
	}
	unionCount := len(unionSet)

	if unionCount == 0 {
		return 1.0
	}
	if intersectionCount == 0 {
		return 0.0
	}
	return float64(intersectionCount) / float64(unionCount)
}

func main() {
	tests := [][]int32{
		{},
		{1, 2, 3, 4, 5},
		{1, 3, 5, 7, 9},
		{2, 4, 6, 8, 10},
		{2, 3, 5, 7},
		{8},
	}

	fmt.Println("     Set A              Set B         J(A, B)")
	fmt.Println("---------------------------------------------")
	
	for _, a := range tests {
		for _, b := range tests {
			aStr := vectorToString(a)
			bStr := vectorToString(b)
			// Pad strings to width 19
			aPadded := aStr + strings.Repeat(" ", 19-len(aStr))
			bPadded := bStr + strings.Repeat(" ", 19-len(bStr))
			
			fmt.Printf("%s%s%.5f\n", aPadded, bPadded, jaccardIndex(a, b))
		}
	}
}
