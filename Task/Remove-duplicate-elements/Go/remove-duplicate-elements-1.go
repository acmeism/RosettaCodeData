package main

import "fmt"

func uniq(list []int) []int {
	unique_set := make(map[int]bool, len(list))
	for _, x := range list {
		unique_set[x] = true
	}
	result := make([]int, 0, len(unique_set))
	for x := range unique_set {
		result = append(result, x)
	}
	return result
}

func main() {
	fmt.Println(uniq([]int{1, 2, 3, 2, 3, 4})) // prints: [3 4 1 2] (but in a semi-random order)
}
