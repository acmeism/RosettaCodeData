package main

import "fmt"

func uniq(list []int) []int {
	unique_set := make(map[int]int, len(list))
	i := 0
	for _, x := range list {
		if _, there := unique_set[x]; !there {
			unique_set[x] = i
			i++
		}
	}
	result := make([]int, len(unique_set))
	for x, i := range unique_set {
		result[i] = x
	}
	return result
}

func main() {
	fmt.Println(uniq([]int{1, 2, 3, 2, 3, 4})) // prints: [1 2 3 4]
}
