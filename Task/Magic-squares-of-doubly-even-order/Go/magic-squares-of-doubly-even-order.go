package main

import (
	"fmt"
	"log"
	"strings"
)

const dimensions int = 8

func setupMagicSquareData(d int) ([][]int, error) {
	var output [][]int
	if d < 4 || d%4 != 0 {
		return [][]int{}, fmt.Errorf("Square dimension must be a positive number which is divisible by 4")
	}
	var bits uint = 0x9669 // 0b1001011001101001
	size := d * d
	mult := d / 4
	for i, r := 0, 0; r < d; r++ {
		output = append(output, []int{})
		for c := 0; c < d; i, c = i+1, c+1 {
			bitPos := c/mult + (r/mult)*4
			if (bits & (1 << uint(bitPos))) != 0 {
				output[r] = append(output[r], i+1)
			} else {
				output[r] = append(output[r], size-i)
			}
		}
	}
	return output, nil
}

func arrayItoa(input []int) []string {
	var output []string
	for _, i := range input {
		output = append(output, fmt.Sprintf("%4d", i))
	}
	return output
}

func main() {
	data, err := setupMagicSquareData(dimensions)
	if err != nil {
		log.Fatal(err)
	}
	magicConstant := (dimensions * (dimensions*dimensions + 1)) / 2
	for _, row := range data {
		fmt.Println(strings.Join(arrayItoa(row), " "))
	}
	fmt.Printf("\nMagic Constant: %d\n", magicConstant)
}
