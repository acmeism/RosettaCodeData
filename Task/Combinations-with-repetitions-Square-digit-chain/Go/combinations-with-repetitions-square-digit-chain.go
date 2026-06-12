package main

import (
    "fmt"
    "math"
)

func endsWithOne(n int) bool {
    sum := 0
    for {
        for n > 0 {
            digit := n % 10
            sum += digit * digit
            n /= 10
        }
        if sum == 1 {
            return true
        }
        if sum == 89 {
            return false
        }
        n = sum
        sum = 0
    }
}

func main() {
    ks := [...]int{7, 8, 11, 14, 17}
    for _, k := range ks {
        sums := make([]int64, k*81+1)
        sums[0] = 1
        sums[1] = 0
        for n := 1; n <= k; n++ {
            for i := n * 81; i > 0; i-- {
                for j := 1; j < 10; j++ {
                    s := j * j
                    if s > i {
                        break
                    }
                    sums[i] += sums[i-s]
                }
            }
        }
        count1 := int64(0)
        for i := 1; i <= k*81; i++ {
            if endsWithOne(i) {
                count1 += sums[i]
            }
        }
        limit := int64(math.Pow10(k)) - 1
        fmt.Println("For k =", k, "in the range 1 to", limit)
        fmt.Println(count1, "numbers produce 1 and", limit-count1, "numbers produce 89\n")
    }
}
