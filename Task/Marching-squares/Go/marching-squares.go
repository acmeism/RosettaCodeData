package main

import (
	"fmt"
	"os"
)

// Direction constants
const (
	E = iota
	N
	W
	S
)

// X generates coordinate pairs for a grid of given dimensions
func X(a, b int) [][]int {
	var c [][]int
	for aa := 0; aa <= a; aa++ {
		for bb := 0; bb <= b; bb++ {
			c = append(c, []int{aa, bb})
		}
	}
	return c
}

// any checks if any element in the slice equals val
func any(arr []int, val int) bool {
	for _, v := range arr {
		if v == val {
			return true
		}
	}
	return false
}

// identifyPerimeter identifies the perimeter of a shape in a 2D matrix
func identifyPerimeter(data [][]int) (int, int, string) {
	for _, coords := range X(len(data[0])-1, len(data)-1) {
		x, y := coords[0], coords[1]
		
		if y < len(data) && x < len(data[0]) && data[y][x] != 0 {
			path := ""
			cx, cy := x, y
			var d, p int
			
			for {
				mask := 0
				
				for _, vals := range [][]int{{0, 0, 1}, {1, 0, 2}, {0, 1, 4}, {1, 1, 8}} {
					dx, dy, b := vals[0], vals[1], vals[2]
					mx, my := cx+dx, cy+dy
					
					if mx > 0 && my > 0 && my-1 < len(data) && mx-1 < len(data[0]) && data[my-1][mx-1] != 0 {
						mask += b
					}
				}
				
				if any([]int{1, 5, 13}, mask) {
					d = N
				}
				if any([]int{2, 3, 7}, mask) {
					d = E
				}
				if any([]int{4, 12, 14}, mask) {
					d = W
				}
				if any([]int{8, 10, 11}, mask) {
					d = S
				}
				if mask == 6 {
					if p == N {
						d = W
					} else {
						d = E
					}
				}
				if mask == 9 {
					if p == E {
						d = N
					} else {
						d = S
					}
				}
				
				dirChars := []rune{'E', 'N', 'W', 'S'}
				path += string(dirChars[d])
				p = d
				
				dxVals := []int{1, 0, -1, 0}
				dyVals := []int{0, -1, 0, 1}
				cx += dxVals[d]
				cy += dyVals[d]
				
				if cx == x && cy == y {
					break
				}
			}
			
			return x, -y, path
		}
	}
	
	fmt.Println("That did not work out...")
	os.Exit(1)
	return 0, 0, "" // This line will never be reached due to os.Exit, but needed for compilation
}

func main() {
	M := [][]int{
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
		{0, 0, 1, 1, 0},
		{0, 0, 1, 1, 0},
		{0, 0, 0, 1, 0},
		{0, 0, 0, 0, 0},
	}
	
	x, y, path := identifyPerimeter(M)
	fmt.Printf("X: %d, Y: %d, Path: %s\n", x, y, path)
}
