package main

import (
    "fmt"
    "rcu"
)

func prune(a []int) []int {
    prev := a[0]
    b := []int{prev}
    for i := 1; i < len(a); i++ {
        if a[i] != prev {
            b = append(b, a[i])
            prev = a[i]
        }
    }
    return b
}

func main() {
    var resF, resD, resT, factors1 []int
    factors2 := []int{2}
    factors3 := []int{3}
    var sum1, sum2, sum3 int = 0, 2, 3
    var countF, countD, countT int
    for n := 2; countT < 1 || countD < 30 || countF < 30; n++ {
        factors1 = factors2
        factors2 = factors3
        factors3 = rcu.PrimeFactors(n + 2)
        sum1 = sum2
        sum2 = sum3
        sum3 = rcu.SumInts(factors3)
        if countF < 30 && sum1 == sum2 {
            resF = append(resF, n)
            countF++
        }
        if sum1 == sum2 && sum2 == sum3 {
            resT = append(resT, n)
            countT++
        }
        if countD < 30 {
            factors4 := make([]int, len(factors1))
            copy(factors4, factors1)
            factors5 := make([]int, len(factors2))
            copy(factors5, factors2)
            factors4 = prune(factors4)
            factors5 = prune(factors5)
            if rcu.SumInts(factors4) == rcu.SumInts(factors5) {
                resD = append(resD, n)
                countD++
            }
        }
    }
    fmt.Println("First 30 Ruth-Aaron numbers (factors):")
    fmt.Println(resF)
    fmt.Println("\nFirst 30 Ruth-Aaron numbers (divisors):")
    fmt.Println(resD)
    fmt.Println("\nFirst Ruth-Aaron triple (factors):")
    fmt.Println(resT[0])

    resT = resT[:0]
    factors1 = factors1[:0]
    factors2 = factors2[:1]
    factors2[0] = 2
    factors3 = factors3[:1]
    factors3[0] = 3
    countT = 0
    for n := 2; countT < 1; n++ {
        factors1 = factors2
        factors2 = factors3
        factors3 = prune(rcu.PrimeFactors(n + 2))
        sum1 = sum2
        sum2 = sum3
        sum3 = rcu.SumInts(factors3)
        if sum1 == sum2 && sum2 == sum3 {
            resT = append(resT, n)
            countT++
        }
    }
    fmt.Println("\nFirst Ruth-Aaron triple (divisors):")
    fmt.Println(resT[0])
}
