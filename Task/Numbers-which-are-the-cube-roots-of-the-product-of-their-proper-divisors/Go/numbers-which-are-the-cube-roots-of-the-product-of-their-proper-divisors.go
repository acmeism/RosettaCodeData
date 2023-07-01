package main

import (
    "fmt"
    "math"
    "rcu"
)

func divisorCount(n int) int {
    k := 1
    if n%2 == 1 {
        k = 2
    }
    count := 0
    sqrt := int(math.Sqrt(float64(n)))
    for i := 1; i <= sqrt; i += k {
        if n%i == 0 {
            count++
            j := n / i
            if j != i {
                count++
            }
        }
    }
    return count
}

func main() {
    var numbers50 []int
    count := 0
    for n := 1; count < 50000; n++ {
        dc := divisorCount(n)
        if n == 1 || dc == 8 {
            count++
            if count <= 50 {
                numbers50 = append(numbers50, n)
                if count == 50 {
                    rcu.PrintTable(numbers50, 10, 3, false)
                }
            } else if count == 500 {
                fmt.Printf("\n500th   : %s", rcu.Commatize(n))
            } else if count == 5000 {
                fmt.Printf("\n5,000th : %s", rcu.Commatize(n))
            } else if count == 50000 {
                fmt.Printf("\n50,000th: %s\n", rcu.Commatize(n))
            }
        }
    }
}
