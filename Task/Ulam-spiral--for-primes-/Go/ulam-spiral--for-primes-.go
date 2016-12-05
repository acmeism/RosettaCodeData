package main

import (
	"math"
	"fmt"
)

type Direction byte

const (
	RIGHT Direction = iota
	UP
	LEFT
	DOWN
)

func generate(n,i int, c byte) {
	s := make([][]string, n)
	for i := 0; i < n; i++ { s[i] = make([]string, n) }
	dir := RIGHT
	y := n / 2
	var x int
	if (n % 2 == 0) { x = y - 1 } else { x = y } // shift left for even n's

	for j := i; j <= n * n - 1 + i; j++ {
		if (isPrime(j)) {
			if (c == 0) { s[y][x] = fmt.Sprintf("%3d", j) } else { s[y][x] = fmt.Sprintf("%2c ", c) }
		} else { s[y][x] = "---" }

		switch dir {
		case RIGHT : if (x <= n - 1 && s[y - 1][x] == "" && j > i) { dir = UP }
		case UP : if (s[y][x - 1] == "") { dir = LEFT }
		case LEFT : if (x == 0 || s[y + 1][x] == "") { dir = DOWN }
		case DOWN : if (s[y][x + 1] == "") { dir = RIGHT }
		}

		switch dir {
		case RIGHT : x += 1
		case UP : y -= 1
		case LEFT : x -= 1
		case DOWN : y += 1
		}
	}

	for _, row := range s { fmt.Println(fmt.Sprintf("%v", row)) }
	fmt.Println()
}

func isPrime(a int) bool {
	if (a == 2) { return true }
	if (a <= 1 || a % 2 == 0) { return false }
	max := int(math.Sqrt(float64(a)))
	for n := 3; n <= max; n += 2 { if (a % n == 0) { return false } }
	return true
}

func main() {
	generate(9, 1, 0) // with digits
	generate(9, 1, '*') // with *
}
