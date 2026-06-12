package main

import (
	"fmt"
	"math/big"
	"slices"
)

// isZigzag checks if the array has the zigzag property
func isZigzag(arr []int) bool {
	if arr == nil || len(arr) < 2 {
		return true
	}

	for i := 0; i < len(arr)-1; i++ {
		if i%2 == 0 { // even index i
			if arr[i] >= arr[i+1] {
				return false
			}
		} else { // odd index i
			if arr[i] <= arr[i+1] {
				return false
			}
		}
	}
	return true
}

// nextZigzagPerm mutates arr into the next permutation with the zigzag property.
// Returns true if a new permutation was found, otherwise false.
func nextZigzagPerm(arr []int) bool {
	for {
		if arr == nil || len(arr) <= 1 {
			break
		}

		// Find last index where arr[i] < arr[i+1]
		i := -1
		for idx := 0; idx < len(arr)-1; idx++ {
			if arr[idx] < arr[idx+1] {
				i = idx
			}
		}

		if i == -1 {
			// Reverse the array
			reverseArray(arr, 0, len(arr)-1)
			break
		}

		// Find last index where arr[j] > arr[i]
		j := i + 1
		for idx := i + 1; idx < len(arr); idx++ {
			if arr[idx] > arr[i] {
				j = idx
			}
		}

		// Swap elements at i and j
		swap(arr, i, j)

		// Reverse the subarray from i+1 to end
		reverseArray(arr, i+1, len(arr)-1)

		if isZigzag(arr) {
			return true
		}
	}
	return false
}

// swap swaps two elements in an array
func swap(arr []int, i, j int) {
	arr[i], arr[j] = arr[j], arr[i]
}

// reverseArray reverses a portion of an array
func reverseArray(arr []int, start, end int) {
	for start < end {
		swap(arr, start, end)
		start++
		end--
	}
}

// Zigzags is a lazy iterator to generate zigzag permutations of length n
type Zigzags struct {
	n       int
	state   []int
	hasNext bool
}

// NewZigzags creates a new Zigzags iterator
func NewZigzags(n int) *Zigzags {
	state := make([]int, n)
	for i := 0; i < n; i++ {
		state[i] = i + 1
	}
	return &Zigzags{
		n:       n,
		state:   state,
		hasNext: true,
	}
}

// HasNext returns true if there are more zigzag permutations
func (z *Zigzags) HasNext() bool {
	return z.hasNext
}

// Next returns the next zigzag permutation
func (z *Zigzags) Next() []int {
	if !z.hasNext {
		panic("no more elements")
	}

	result := make([]int, len(z.state))
	copy(result, z.state)
	z.hasNext = nextZigzagPerm(z.state)
	return result
}

// testZigzags generates zigzag permutation listings and prints totals
func testZigzags(nListings, nTotals int) {
	// Generate zigzag permutation listings
	for n := 1; n <= nListings; n++ {
		fmt.Printf("\nZigZag Permutations for N = %d:\n", n)
		if n < 3 {
			fmt.Print("[")
			for i := 1; i <= n; i++ {
				fmt.Print(i)
				if i < n {
					fmt.Print(", ")
				}
			}
			fmt.Println("]")
		} else {
			zigzags := NewZigzags(n)
			for zigzags.HasNext() {
				perm := zigzags.Next()
				fmt.Printf("%v ", perm)
			}
			fmt.Println()
		}
	}

	// Calculate and print totals
	zzn := []*big.Int{big.NewInt(1)}

	fmt.Println("\nN     Zigzags")
	fmt.Println("--------------------------------")
	fmt.Println(" 1    1")

	for m := 1; m < nTotals; m++ {
		var cumsum []*big.Int
		total := big.NewInt(0)

		if m%2 == 0 {
			// Reverse iteration
			for i := len(zzn) - 1; i >= 0; i-- {
				total = new(big.Int).Add(total, zzn[i])
				cumsum = append(cumsum, new(big.Int).Set(total))
			}
			slices.Reverse(cumsum)
			zzn = make([]*big.Int, len(cumsum)+1)
			copy(zzn, cumsum)
			zzn[len(zzn)-1] = big.NewInt(0)
		} else {
			for _, x := range zzn {
				total = new(big.Int).Add(total, x)
				cumsum = append(cumsum, new(big.Int).Set(total))
			}
			zzn = make([]*big.Int, len(cumsum)+1)
			zzn[0] = big.NewInt(0)
			copy(zzn[1:], cumsum)
		}

		sum := big.NewInt(0)
		for _, x := range zzn {
			sum = new(big.Int).Add(sum, x)
		}
		fmt.Printf("%2d    %s\n", m+1, sum.String())
	}
}

func main() {
	testZigzags(5, 30)
}
