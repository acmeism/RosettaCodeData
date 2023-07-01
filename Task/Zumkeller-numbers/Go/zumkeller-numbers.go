package main

import "fmt"

func getDivisors(n int) []int {
    divs := []int{1, n}
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            divs = append(divs, i)
            if i != j {
                divs = append(divs, j)
            }
        }
    }
    return divs
}

func sum(divs []int) int {
    sum := 0
    for _, div := range divs {
        sum += div
    }
    return sum
}

func isPartSum(divs []int, sum int) bool {
    if sum == 0 {
        return true
    }
    le := len(divs)
    if le == 0 {
        return false
    }
    last := divs[le-1]
    divs = divs[0 : le-1]
    if last > sum {
        return isPartSum(divs, sum)
    }
    return isPartSum(divs, sum) || isPartSum(divs, sum-last)
}

func isZumkeller(n int) bool {
    divs := getDivisors(n)
    sum := sum(divs)
    // if sum is odd can't be split into two partitions with equal sums
    if sum%2 == 1 {
        return false
    }
    // if n is odd use 'abundant odd number' optimization
    if n%2 == 1 {
        abundance := sum - 2*n
        return abundance > 0 && abundance%2 == 0
    }
    // if n and sum are both even check if there's a partition which totals sum / 2
    return isPartSum(divs, sum/2)
}

func main() {
    fmt.Println("The first 220 Zumkeller numbers are:")
    for i, count := 2, 0; count < 220; i++ {
        if isZumkeller(i) {
            fmt.Printf("%3d ", i)
            count++
            if count%20 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Println("\nThe first 40 odd Zumkeller numbers are:")
    for i, count := 3, 0; count < 40; i += 2 {
        if isZumkeller(i) {
            fmt.Printf("%5d ", i)
            count++
            if count%10 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Println("\nThe first 40 odd Zumkeller numbers which don't end in 5 are:")
    for i, count := 3, 0; count < 40; i += 2 {
        if (i % 10 != 5) && isZumkeller(i) {
            fmt.Printf("%7d ", i)
            count++
            if count%8 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Println()
}
