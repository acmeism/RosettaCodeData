package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {

	rand.Seed(time.Now().UnixNano())

	var n int = 3 // Change to define board size
	var moves int = 0
	
	a := make([][]int, n)
	for i := range a {
		a[i] = make([]int, n)
		for j := range a {
			a[i][j] = rand.Intn(2)
		}
	}

    b := make([][]int, len(a))
	for i := range a {
		b[i] = make([]int, len(a[i]))
		copy(b[i], a[i])
	}
	
	for i := rand.Intn(100); i > 0 || compareSlices(a, b) == true; i-- {
		b = flipCol(b, rand.Intn(n) + 1)
		b = flipRow(b, rand.Intn(n) + 1)
	}
	
	fmt.Println("Target:")
	drawBoard(a)
	fmt.Println("\nBoard:")
	drawBoard(b)
	
	var rc rune
	var num int
	
	for {
		for{
			fmt.Printf("\nFlip row (r) or column (c)  1 .. %d (c1, ...): ", n)
			_, err := fmt.Scanf("%c%d", &rc, &num)
			if err != nil {
				fmt.Println(err)
				continue
			}
			if num < 1 || num > n {
				fmt.Println("Wrong command!")
				continue
			}
			break
		}
		
		switch rc {
			case 'c':
				fmt.Printf("Column %v will be flipped\n", num)
				flipCol(b, num)
			case 'r':
				fmt.Printf("Row %v will be flipped\n", num)
				flipRow(b, num)
			default:
				fmt.Println("Wrong command!")
				continue
		}
		
		moves++
		fmt.Println("\nMoves taken: ", moves)
		
		fmt.Println("Target:")
		drawBoard(a)
		fmt.Println("\nBoard:")
		drawBoard(b)
	
		if compareSlices(a, b) {
			fmt.Printf("Finished. You win with %d moves!\n", moves)
			break
		}
	}
}

func drawBoard (m [][]int) {
	fmt.Print("   ")
	for i := range m {
		fmt.Printf("%d ", i+1)	
	}
	for i := range m {
		fmt.Println()
		fmt.Printf("%d ", i+1)
		for _, val := range m[i] {
			fmt.Printf(" %d", val)
		}
	}
	fmt.Print("\n")
}

func flipRow(m [][]int, row int) ([][]int) {
	for j := range m {
		m[row-1][j] ^= 1
	}
	return m
}

func flipCol(m [][]int, col int) ([][]int) {
	for j := range m {
		m[j][col-1] ^= 1
	}
	return m
}

func compareSlices(m [][]int, n[][]int) bool {
	o := true
	for i := range m {
		for j := range m {
			if m[i][j] != n[i][j] { o = false }
		}
	}
	return o
}
