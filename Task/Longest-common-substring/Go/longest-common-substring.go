package main

import "fmt"

func lcs(a, b string) (output string) {
    lengths := make([]int, len(a)*len(b))
    greatestLength := 0
    for i, x := range a {
        for j, y := range b {
            if x == y {
                if i == 0 || j == 0 {
                    lengths[i*len(b)+j] = 1
                } else {
                    lengths[i*len(b)+j] = lengths[(i-1)*len(b)+j-1] + 1
                }
                if lengths[i*len(b)+j] > greatestLength {
                    greatestLength = lengths[i*len(b)+j]
                    output = a[i-greatestLength+1 : i+1]
                }
            }
        }
    }
    return
}

func main() {
    fmt.Println(lcs("thisisatest", "testing123testing"))
}
