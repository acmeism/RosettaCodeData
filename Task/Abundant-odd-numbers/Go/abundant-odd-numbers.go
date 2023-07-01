package main

import (
    "fmt"
    "strconv"
)

func divisors(n int) []int {
    divs := []int{1}
    divs2 := []int{}
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            divs = append(divs, i)
            if i != j {
                divs2 = append(divs2, j)
            }
        }
    }
    for i := len(divs2) - 1; i >= 0; i-- {
        divs = append(divs, divs2[i])
    }
    return divs
}

func sum(divs []int) int {
    tot := 0
    for _, div := range divs {
        tot += div
    }
    return tot
}

func sumStr(divs []int) string {
    s := ""
    for _, div := range divs {
        s += strconv.Itoa(div) + " + "
    }
    return s[0 : len(s)-3]
}

func abundantOdd(searchFrom, countFrom, countTo int, printOne bool) int {
    count := countFrom
    n := searchFrom
    for ; count < countTo; n += 2 {
        divs := divisors(n)
        if tot := sum(divs); tot > n {
            count++
            if printOne && count < countTo {
                continue
            }
            s := sumStr(divs)
            if !printOne {
                fmt.Printf("%2d. %5d < %s = %d\n", count, n, s, tot)
            } else {
                fmt.Printf("%d < %s = %d\n", n, s, tot)
            }
        }
    }
    return n
}

func main() {
    const max = 25
    fmt.Println("The first", max, "abundant odd numbers are:")
    n := abundantOdd(1, 0, 25, false)

    fmt.Println("\nThe one thousandth abundant odd number is:")
    abundantOdd(n, 25, 1000, true)

    fmt.Println("\nThe first abundant odd number above one billion is:")
    abundantOdd(1e9+1, 0, 1, true)
}
