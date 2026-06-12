package main

import "fmt"

func main() {
    diffs := []int{-7, -5, -3, -2, 2, 3, 5, 7}
    possibles := make([][]int, 10)
        for i := 0; i < 10; i++ {
        possibles[i] = []int{}
        for _, d := range diffs {
            sum := i + d
            if sum >= 0 && sum < 10 {
                possibles[i] = append(possibles[i], sum)
            }
        }
    }

    places := 10
    start := 1
    strangeOnes := []int{start}
    for i := 2; i <= places; i++ {
        var newOnes []int
        for _, n := range strangeOnes {
            for _, nextN := range possibles[n%10] {
                newOnes = append(newOnes, n*10+nextN)
            }
        }
        strangeOnes = newOnes
    }
    fmt.Println("Found", len(strangeOnes), places, "\b-digit strange numbers beginning with", start)
}
