package main

import (
    "fmt"
    "rcu"
)

func genUpsideDown(limit int) chan int {
    ch := make(chan int)
    wrappings := [][2]int{
        {1, 9}, {2, 8}, {3, 7}, {4, 6}, {5, 5},
        {6, 4}, {7, 3}, {8, 2}, {9, 1},
    }
    evens := []int{19, 28, 37, 46, 55, 64, 73, 82, 91}
    odds := []int{5}
    oddIndex := 0
    evenIndex := 0
    ndigits := 1
    pow := 100
    count := 0
    go func() {
        for count < limit {
            if ndigits%2 == 1 {
                if len(odds) > oddIndex {
                    ch <- odds[oddIndex]
                    count++
                    oddIndex++
                } else {
                    // build next odds, but switch to evens
                    var nextOdds []int
                    for _, w := range wrappings {
                        for _, i := range odds {
                            nextOdds = append(nextOdds, w[0]*pow+i*10+w[1])
                        }
                    }
                    odds = nextOdds
                    ndigits++
                    pow *= 10
                    oddIndex = 0
                }
            } else {
                if len(evens) > evenIndex {
                    ch <- evens[evenIndex]
                    count++
                    evenIndex++
                } else {
                    // build next evens, but switch to odds
                    var nextEvens []int
                    for _, w := range wrappings {
                        for _, i := range evens {
                            nextEvens = append(nextEvens, w[0]*pow+i*10+w[1])
                        }
                    }
                    evens = nextEvens
                    ndigits++
                    pow *= 10
                    evenIndex = 0
                }
            }
        }
        close(ch)
    }()
    return ch
}

func main() {
    const limit = 50_000_000
    count := 0
    var ud50s []int
    pow := 50
    for n := range genUpsideDown(limit) {
        count++
        if count < 50 {
            ud50s = append(ud50s, n)
        } else if count == 50 {
            ud50s = append(ud50s, n)
            fmt.Println("First 50 upside down numbers:")
            rcu.PrintTable(ud50s, 10, 5, true)
            fmt.Println()
            pow = 500
        } else if count == pow {
            fmt.Printf("%sth : %s\n", rcu.Commatize(pow), rcu.Commatize(n))
            pow *= 10
        }
    }
}
