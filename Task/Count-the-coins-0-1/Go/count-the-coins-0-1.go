package main

import "fmt"

var cnt = 0  // order unimportant
var cnt2 = 0 // order important
var wdth = 0 // for printing purposes

func factorial(n int) int {
    prod := 1
    for i := 2; i <= n; i++ {
        prod *= i
    }
    return prod
}

func count(want int, used []int, sum int, have, uindices, rindices []int) {
    if sum == want {
        cnt++
        cnt2 += factorial(len(used))
        if cnt < 11 {
            uindicesStr := fmt.Sprintf("%v", uindices)
            fmt.Printf("  indices %*s => used %v\n", wdth, uindicesStr, used)
        }
    } else if sum < want && len(have) != 0 {
        thisCoin := have[0]
        index := rindices[0]
        rest := have[1:]
        rindices := rindices[1:]
        count(want, append(used, thisCoin), sum+thisCoin, rest,
            append(uindices, index), rindices)
        count(want, used, sum, rest, uindices, rindices)
    }
}

func countCoins(want int, coins []int, width int) {
    fmt.Printf("Sum %d from coins %v\n", want, coins)
    cnt = 0
    cnt2 = 0
    wdth = -width
    rindices := make([]int, len(coins))
    for i := range rindices {
        rindices[i] = i
    }
    count(want, []int{}, 0, coins, []int{}, rindices)
    if cnt > 10 {
        fmt.Println("  .......")
        fmt.Println("  (only the first 10 ways generated are shown)")
    }
    fmt.Println("Number of ways - order unimportant :", cnt, "(as above)")
    fmt.Println("Number of ways - order important   :", cnt2, "(all perms of above indices)\n")
}

func main() {
    countCoins(6, []int{1, 2, 3, 4, 5}, 7)
    countCoins(6, []int{1, 1, 2, 3, 3, 4, 5}, 9)
    countCoins(40, []int{1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100}, 20)
}
