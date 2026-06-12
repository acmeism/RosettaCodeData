package main

import (
	"fmt"
	"sort"
)

func printVector(list []uint32) {
	fmt.Print("[")
	for i := 0; i < len(list)-1; i++ {
		fmt.Printf("%d, ", list[i])
	}
	fmt.Printf("%d]", list[len(list)-1])
}

func factorial(n uint32) uint64 {
	if n == 0 {
		return 1
	}
	return uint64(n) * factorial(n-1)
}

func sum(numbers []uint32) uint32 {
	var total uint32
	for _, num := range numbers {
		total += num
	}
	return total
}

func takedownCount(numbers []uint32) uint64 {
	total := sum(numbers)
	result := factorial(total)
	for _, number := range numbers {
		result = result / factorial(number)
	}
	return result
}

func nextPermutation(a []uint32) bool {
	// Find the largest index i such that a[i] < a[i+1]
	i := len(a) - 2
	for i >= 0 && a[i] >= a[i+1] {
		i--
	}
	if i < 0 {
		return false
	}

	// Find the largest index j such that a[i] < a[j]
	j := len(a) - 1
	for a[j] <= a[i] {
		j--
	}

	// Swap a[i], a[j]
	a[i], a[j] = a[j], a[i]

	// Reverse the sub-array a[i+1:]
	for k, l := i+1, len(a)-1; k < l; k, l = k+1, l-1 {
		a[k], a[l] = a[l], a[k]
	}
	return true
}

func takedownWays(numbers []uint32, rowSize uint32) {
	limits := make([]uint32, len(numbers))
	var sum uint32
	multiNumbers := []uint32{}
	for i := 0; i < len(numbers); i++ {
		sum += numbers[i]
		limits[i] = sum
		for j := uint32(0); j < numbers[i]; j++ {
			multiNumbers = append(multiNumbers, uint32(i+1))
		}
	}

	takedown := takedownCount(numbers)
	fmt.Printf("List of %d permutations for %d groups with lanterns per group ", takedown, len(numbers))
	printVector(numbers)
	fmt.Println(" :")

	var permutationCount uint32
	
	// First permutation
	sort.Slice(multiNumbers, func(i, j int) bool {
		return multiNumbers[i] < multiNumbers[j]
	})
	
	for {
		current := make([]uint32, len(limits))
		copy(current, limits)
		ways := make([]uint32, sum)

		for i := uint32(0); i < sum; i++ {
			ways[i] = current[multiNumbers[i]-1]
			current[multiNumbers[i]-1]--
		}

		printVector(ways)
		fmt.Print("  ")
		permutationCount++
		if permutationCount%rowSize == 0 {
			fmt.Println()
		}

		if !nextPermutation(multiNumbers) {
			break
		}
	}
}

func main() {
	tests := [][]uint32{{1, 2, 3}, {2, 2, 3, 3}, {10, 2}}
	fmt.Println("Lantern arrangement => number of takedown ways:")
	for _, numbers := range tests {
		printVector(numbers)
		fmt.Printf(" => %d\n", takedownCount(numbers))
	}
	fmt.Println()

	takedownWays([]uint32{1, 2, 3}, 5)
}
