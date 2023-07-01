package main

import (
    "fmt"
    "strconv"
)

func isPrime(n int) bool {
    switch {
    case n < 2:
        return false
    case n%2 == 0:
        return n == 2
    case n%3 == 0:
        return n == 3
    default:
        d := 5
        for d*d <= n {
            if n%d == 0 {
                return false
            }
            d += 2
            if n%d == 0 {
                return false
            }
            d += 4
        }
        return true
    }
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    fmt.Println("The first 35 unprimeable numbers are:")
    count := 0           // counts all unprimeable numbers
    var firstNum [10]int // stores the first unprimeable number ending with each digit
outer:
    for i, countFirst := 100, 0; countFirst < 10; i++ {
        if isPrime(i) {
            continue // unprimeable number must be composite
        }
        s := strconv.Itoa(i)
        le := len(s)
        b := []byte(s)
        for j := 0; j < le; j++ {
            for k := byte('0'); k <= '9'; k++ {
                if s[j] == k {
                    continue
                }
                b[j] = k
                n, _ := strconv.Atoi(string(b))
                if isPrime(n) {
                    continue outer
                }
            }
            b[j] = s[j] // restore j'th digit to what it was originally
        }
        lastDigit := s[le-1] - '0'
        if firstNum[lastDigit] == 0 {
            firstNum[lastDigit] = i
            countFirst++
        }
        count++
        if count <= 35 {
            fmt.Printf("%d ", i)
        }
        if count == 35 {
            fmt.Print("\n\nThe 600th unprimeable number is: ")
        }
        if count == 600 {
            fmt.Printf("%s\n\n", commatize(i))
        }
    }

    fmt.Println("The first unprimeable number that ends in:")
    for i := 0; i < 10; i++ {
        fmt.Printf("  %d is: %9s\n", i, commatize(firstNum[i]))
    }
}
