package main

import (
	"fmt"
	"math/rand"
	"time"
)

func cyclesort(ints []int) int {
	writes := 0

	for cyclestart := 0; cyclestart < len(ints)-1; cyclestart++ {
		item := ints[cyclestart]

		pos := cyclestart

		for i := cyclestart + 1; i < len(ints); i++ {
			if ints[i] < item {
				pos++
			}
		}

		if pos == cyclestart {
			continue
		}

		for item == ints[pos] {
			pos++
		}

		ints[pos], item = item, ints[pos]

		writes++

		for pos != cyclestart {
			pos = cyclestart
			for i := cyclestart + 1; i < len(ints); i++ {
				if ints[i] < item {
					pos++
				}
			}

			for item == ints[pos] {
				pos++
			}

			ints[pos], item = item, ints[pos]
			writes++
		}
	}

	return writes
}

func main() {
	rand.Seed(time.Now().Unix())

	ints := rand.Perm(10)

	fmt.Println(ints)
	fmt.Printf("writes %d\n", cyclesort(ints))
	fmt.Println(ints)
}
