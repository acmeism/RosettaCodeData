package main

import (
    "fmt"
    "log"
)

func magicSquareOdd(n int) ([][]int, error) {
    if n < 3 || n%2 == 0 {
        return nil, fmt.Errorf("base must be odd and > 2")
    }
    value := 1
    gridSize := n * n
    c, r := n/2, 0
    result := make([][]int, n)

    for i := 0; i < n; i++ {
        result[i] = make([]int, n)
    }

    for value <= gridSize {
        result[r][c] = value
        if r == 0 {
            if c == n-1 {
                r++
            } else {
                r = n - 1
                c++
            }
        } else if c == n-1 {
            r--
            c = 0
        } else if result[r-1][c+1] == 0 {
            r--
            c++
        } else {
            r++
        }
        value++
    }
    return result, nil
}

func magicSquareSinglyEven(n int) ([][]int, error) {
    if n < 6 || (n-2)%4 != 0 {
        return nil, fmt.Errorf("base must be a positive multiple of 4 plus 2")
    }
    size := n * n
    halfN := n / 2
    subSquareSize := size / 4
    subSquare, err := magicSquareOdd(halfN)
    if err != nil {
        return nil, err
    }
    quadrantFactors := [4]int{0, 2, 3, 1}
    result := make([][]int, n)

    for i := 0; i < n; i++ {
        result[i] = make([]int, n)
    }

    for r := 0; r < n; r++ {
        for c := 0; c < n; c++ {
            quadrant := r/halfN*2 + c/halfN
            result[r][c] = subSquare[r%halfN][c%halfN]
            result[r][c] += quadrantFactors[quadrant] * subSquareSize
        }
    }

    nColsLeft := halfN / 2
    nColsRight := nColsLeft - 1

    for r := 0; r < halfN; r++ {
        for c := 0; c < n; c++ {
            if c < nColsLeft || c >= n-nColsRight ||
                (c == nColsLeft && r == nColsLeft) {
                if c == 0 && r == nColsLeft {
                    continue
                }
                tmp := result[r][c]
                result[r][c] = result[r+halfN][c]
                result[r+halfN][c] = tmp
            }
        }
    }
    return result, nil
}

func main() {
    const n = 6
    msse, err := magicSquareSinglyEven(n)
    if err != nil {
        log.Fatal(err)
    }
    for _, row := range msse {
        for _, x := range row {
            fmt.Printf("%2d ", x)
        }
        fmt.Println()
    }
    fmt.Printf("\nMagic constant: %d\n", (n*n+1)*n/2)
}
