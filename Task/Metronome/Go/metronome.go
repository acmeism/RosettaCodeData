package main

import (
	"fmt"
	"time"
)

func main() {
	var bpm = 72.0 // Beats Per Minute
	var bpb = 4    // Beats Per Bar

	d := time.Duration(float64(time.Minute) / bpm)
	fmt.Println("Delay:", d)
	t := time.NewTicker(d)
	i := 1
	for _ = range t.C {
		i--
		if i == 0 {
			i = bpb
			fmt.Printf("\nTICK ")
		} else {
			fmt.Printf("tick ")
		}
	}
}
