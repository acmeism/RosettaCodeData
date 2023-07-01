package main

import (
	"fmt"
	"log"
)

func main() {
	fmt.Println(eulerSum())
}

func eulerSum() (x0, x1, x2, x3, y int) {
	var pow5 [250]int
	for i := range pow5 {
		pow5[i] = i * i * i * i * i
	}
	for x0 = 4; x0 < len(pow5); x0++ {
		for x1 = 3; x1 < x0; x1++ {
			for x2 = 2; x2 < x1; x2++ {
				for x3 = 1; x3 < x2; x3++ {
					sum := pow5[x0] +
						pow5[x1] +
						pow5[x2] +
						pow5[x3]
					for y = x0 + 1; y < len(pow5); y++ {
						if sum == pow5[y] {
							return
						}
					}
				}
			}
		}
	}
	log.Fatal("no solution")
	return
}
