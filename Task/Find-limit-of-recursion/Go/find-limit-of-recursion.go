package main

import (
	"flag"
	"fmt"
	"runtime/debug"
)

func main() {
	stack := flag.Int("stack", 0, "maximum per goroutine stack size or 0 for the default")
	flag.Parse()
	if *stack > 0 {
		debug.SetMaxStack(*stack)
	}
	r(1)
}

func r(l int) {
	if l%1000 == 0 {
		fmt.Println(l)
	}
	r(l + 1)
}
