package main

import "fmt"

func numPrimeFactors(x uint) int {
	var p uint = 2
	var pf int
	if x == 1 {
		return 1
	}
	for {
		if (x % p) == 0 {
			pf++
			x /= p
			if x == 1 {
				return pf
			}
		} else {
			p++
		}
	}
}

func primeFactors(x uint, arr []uint) {
	var p uint = 2
	var pf int
	if x == 1 {
		arr[pf] = 1
		return
	}
	for {
		if (x % p) == 0 {
			arr[pf] = p
			pf++
			x /= p
			if x == 1 {
				return
			}
		} else {
			p++
		}
	}
}

func sumDigits(x uint) uint {
	var sum uint
	for x != 0 {
		sum += x % 10
		x /= 10
	}
	return sum
}

func sumFactors(arr []uint, size int) uint {
	var sum uint
	for a := 0; a < size; a++ {
		sum += sumDigits(arr[a])
	}
	return sum
}

func listAllSmithNumbers(maxSmith uint) {
	var arr []uint
	var a uint
	for a = 4; a < maxSmith; a++ {
		numfactors := numPrimeFactors(a)
		arr = make([]uint, numfactors)
		if numfactors < 2 {
			continue
		}
		primeFactors(a, arr)
		if sumDigits(a) == sumFactors(arr, numfactors) {
			fmt.Printf("%4d ", a)
		}
	}
}

func main() {
	const maxSmith = 10000
	fmt.Printf("All the Smith Numbers less than %d are:\n", maxSmith)
	listAllSmithNumbers(maxSmith)
	fmt.Println()
}
