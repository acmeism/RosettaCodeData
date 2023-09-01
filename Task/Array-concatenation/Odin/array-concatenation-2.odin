package main

import "core:fmt"
import "core:slice"

main :: proc() {
	x: [3]int = {1, 2, 3}
	y: [3]int = {4, 5, 6}

    xy := slice.concatenate([][]int{x[:], y[:]})
    defer delete(xy)

	fmt.println(xy)
}
