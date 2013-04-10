package main

import "fmt"

func picks(picked []int, pos, need int, c chan[]int, do_wait bool) {
	if need == 0 {
		if do_wait {
			c <- picked
			<-c
		} else { // if we want only the count, there's no need to
			 // sync between coroutines; let it clobber the array
			c <- []int {}
		}
		return
	}

	if pos <= 0 {
		if need == len(picked) { c <- nil }
		return
	}

	picked[len(picked) - need] = pos - 1
	picks(picked, pos, need - 1, c, do_wait) // choose the current donut
	picks(picked, pos - 1, need, c, do_wait) // or don't
}

func main() {
	donuts := []string {"iced", "jam", "plain" }

	picked := make([]int, 2)
	ch := make(chan []int)

	// true: tell the channel to wait for each sending, because
	// otherwise the picked array may get clobbered before we can do
	// anything to it
	go picks(picked, len(donuts), len(picked), ch, true)

	var cc []int
	for {
		if cc = <-ch; cc == nil { break }
		for _, i := range cc {
			fmt.Printf("%s ", donuts[i])
		}
		fmt.Println()
		ch <- nil // sync
	}

	picked = make([]int, 3)
	// this time we only want the count, so tell goroutine to keep going
	// and work the channel buffer
	go picks(picked, 10, len(picked), ch, false)
	count := 0
	for {
		if cc = <-ch; cc == nil { break }
		count++
	}
	fmt.Printf("\npicking 3 of 10: %d\n", count)
}
