package main

import (
    "fmt"
    "time"
)

func sumDigits(n int) int {
    sum := 0
    for n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}

func main() {
    st := time.Now()
    count := 0
    var selfs []int
    i := 1
    pow := 10
    digits := 1
    offset := 9
    lastSelf := 0
    for count < 1e8 {
        isSelf := true
        start := max(i-offset, 0)
        sum := sumDigits(start)
        for j := start; j < i; j++ {
            if j+sum == i {
                isSelf = false
                break
            }
            if (j+1)%10 != 0 {
                sum++
            } else {
                sum = sumDigits(j + 1)
            }
        }
        if isSelf {
            count++
            lastSelf = i
            if count <= 50 {
                selfs = append(selfs, i)
                if count == 50 {
                    fmt.Println("The first 50 self numbers are:")
                    fmt.Println(selfs)
                }
            }
        }
        i++
        if i%pow == 0 {
            pow *= 10
            digits++
            offset = digits * 9
        }
    }
    fmt.Println("\nThe 100 millionth self number is", lastSelf)
    fmt.Println("Took", time.Since(st))
}
