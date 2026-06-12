package main

import (
	"fmt"
	"sort"
)

func display(matrix [][]int32) {
	for _, row := range matrix {
		for _, element := range row {
			fmt.Printf("%3d", element)
		}
		fmt.Println()
	}
	fmt.Println()
}

func signChangeCount(row []int32) uint32 {
	signChanges := uint32(0)
	for i := 1; i < len(row); i++ {
		if row[i-1] == -row[i] {
			signChanges++
		}
	}
	return signChanges
}

func walshMatrix(size uint32) [][]int32 {
	walsh := make([][]int32, size)
	for i := range walsh {
		walsh[i] = make([]int32, size)
	}
	walsh[0][0] = 1

	k := uint32(1)
	for k < size {
		for i := uint32(0); i < k; i++ {
			for j := uint32(0); j < k; j++ {
				walsh[i+k][j] = walsh[i][j]
				walsh[i][j+k] = walsh[i][j]
				walsh[i+k][j+k] = -walsh[i][j]
			}
		}
		k += k
	}
	return walsh
}

func main() {
	matrixTypes := []string{"Natural", "Sequency"}
	orders := []uint32{2, 4, 5}

	for _, matrixType := range matrixTypes {
		for _, order := range orders {
			size := uint32(1 << order)
			fmt.Printf("Walsh matrix of order %d, %s order:\n", order, matrixType)
			walsh := walshMatrix(size)
			if matrixType == "Sequency" {
				sort.Slice(walsh, func(i, j int) bool {
					return signChangeCount(walsh[i]) < signChangeCount(walsh[j])
				})
			}
			display(walsh)
		}
	}
}
