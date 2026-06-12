package main

import (
	"fmt"
	"math"
)

func main() {
	result := generateSequence(5, 13)
	fmt.Println(result) // Should print 1001010010100
}

func generateSequence(k int, n int) string {
	var s [][]int

	for i := 0; i < n; i++ {
		var innerList []int
		if i < k {
			innerList = append(innerList, 1)
		} else {
			innerList = append(innerList, 0)
		}
		s = append(s, innerList)
	}

	d := n - k
	n = int(math.Max(float64(k), float64(d)))
	k = int(math.Min(float64(k), float64(d)))
	z := d

	for z > 0 || k > 1 {
		for i := 0; i < k; i++ {
			s[i] = append(s[i], s[len(s)-1-i]...)
		}
		s = s[:len(s)-k]
		z -= k
		d = n - k
		n = int(math.Max(float64(k), float64(d)))
		k = int(math.Min(float64(k), float64(d)))
	}

	var result string
	for _, sublist := range s {
		for _, item := range sublist {
			result += fmt.Sprintf("%d", item)
		}
	}
	return result
}
