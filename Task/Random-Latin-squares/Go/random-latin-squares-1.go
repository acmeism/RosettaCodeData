package main

import (
    "fmt"
    "math/rand"
    "time"
)

type matrix [][]int

func shuffle(row []int, n int) {
    rand.Shuffle(n, func(i, j int) {
        row[i], row[j] = row[j], row[i]
    })
}

func latinSquare(n int) {
    if n <= 0 {
        fmt.Println("[]\n")
        return
    }
    latin := make(matrix, n)
    for i := 0; i < n; i++ {
        latin[i] = make([]int, n)
        if i == n-1 {
            break
        }
        for j := 0; j < n; j++ {
            latin[i][j] = j
        }
    }
    // first row
    shuffle(latin[0], n)

    // middle row(s)
    for i := 1; i < n-1; i++ {
        shuffled := false
    shuffling:
        for !shuffled {
            shuffle(latin[i], n)
            for k := 0; k < i; k++ {
                for j := 0; j < n; j++ {
                    if latin[k][j] == latin[i][j] {
                        continue shuffling
                    }
                }
            }
            shuffled = true
        }
    }

    // last row
    for j := 0; j < n; j++ {
        used := make([]bool, n)
        for i := 0; i < n-1; i++ {
            used[latin[i][j]] = true
        }
        for k := 0; k < n; k++ {
            if !used[k] {
                latin[n-1][j] = k
                break
            }
        }
    }
    printSquare(latin, n)
}

func printSquare(latin matrix, n int) {
    for i := 0; i < n; i++ {
        fmt.Println(latin[i])
    }
    fmt.Println()
}

func main() {
    rand.Seed(time.Now().UnixNano())
    latinSquare(5)
    latinSquare(5)
    latinSquare(10) // for good measure
}
