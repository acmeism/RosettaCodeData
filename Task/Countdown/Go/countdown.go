package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	allNumbers := []int{
		1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100,
	}
	
	// Shuffle the slice
	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(allNumbers), func(i, j int) {
		allNumbers[i], allNumbers[j] = allNumbers[j], allNumbers[i]
	})
	
	numberLists := [][]int{
		{3, 6, 25, 50, 75, 100},
		{100, 75, 50, 25, 6, 3},
		{8, 4, 4, 6, 8, 9},
		allNumbers[:6],
	}
	
	targetList := []int{952, 952, 594, rand.Intn(899) + 101}
	
	for i := 0; i < len(targetList); i++ {
		fmt.Printf("Using : %v\n", numberLists[i])
		fmt.Printf("Target: %d\n", targetList[i])
		done := countdown(numberLists[i], targetList[i])
		if !done {
			fmt.Println("No solution found")
		}
		fmt.Println()
	}
}

func countdown(numbers []int, target int) bool {
	if len(numbers) <= 1 {
		return false
	}
	
	for i, n0 := range numbers {
		numbers1 := make([]int, 0, len(numbers)-1)
		numbers1 = append(numbers1, numbers[:i]...)
		numbers1 = append(numbers1, numbers[i+1:]...)
		
		for j, n1 := range numbers1 {
			numbers2 := make([]int, 0, len(numbers1)-1)
			numbers2 = append(numbers2, numbers1[:j]...)
			numbers2 = append(numbers2, numbers1[j+1:]...)
			
			if n1 >= n0 {
				// Addition
				result := n1 + n0
				numbersNext := make([]int, len(numbers2)+1)
				copy(numbersNext, numbers2)
				numbersNext[len(numbers2)] = result
				if result == target || countdown(numbersNext, target) {
					fmt.Printf("%d = %d + %d\n", result, n1, n0)
					return true
				}
				
				// Multiplication
				if n0 != 1 {
					result = n1 * n0
					numbersNext = make([]int, len(numbers2)+1)
					copy(numbersNext, numbers2)
					numbersNext[len(numbers2)] = result
					if result == target || countdown(numbersNext, target) {
						fmt.Printf("%d = %d * %d\n", result, n1, n0)
						return true
					}
				}
				
				// Subtraction
				if n1 != n0 {
					result = n1 - n0
					numbersNext = make([]int, len(numbers2)+1)
					copy(numbersNext, numbers2)
					numbersNext[len(numbers2)] = result
					if result == target || countdown(numbersNext, target) {
						fmt.Printf("%d = %d - %d\n", result, n1, n0)
						return true
					}
				}
				
				// Division
				if n0 != 1 && n1%n0 == 0 {
					result = n1 / n0
					numbersNext = make([]int, len(numbers2)+1)
					copy(numbersNext, numbers2)
					numbersNext[len(numbers2)] = result
					if result == target || countdown(numbersNext, target) {
						fmt.Printf("%d = %d / %d\n", result, n1, n0)
						return true
					}
				}
			}
		}
	}
	return false
}
