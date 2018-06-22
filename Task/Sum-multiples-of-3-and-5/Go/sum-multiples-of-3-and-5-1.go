package main

import "fmt"

func main() {
    fmt.Println(s35(1000))
}

func s35(n int) int {
    n--
    threes := n / 3
    fives := n / 5
    fifteen := n / 15

    threes = 3 * threes * (threes + 1)
    fives = 5 * fives * (fives + 1)
    fifteen = 15 * fifteen * (fifteen + 1)

    n = (threes + fives - fifteen) / 2
	
    return n
}
