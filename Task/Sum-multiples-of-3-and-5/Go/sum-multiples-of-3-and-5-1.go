package main

import "fmt"

func main() {
    fmt.Println(s35(1000))
}

func s35(n int) int {
    n--
    threes := math.Floor(float64(n / 3))
    fives := math.Floor(float64(n / 5))
    fifteen := math.Floor(float64(n / 15))
    return int((3*threes*(threes+1) + 5*fives*(fives+1) - 15*fifteen*(fifteen+1)) / 2)
}
