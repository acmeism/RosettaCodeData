package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "rcu"
)

func main() {
    fact  := big.NewInt(1)
    sum   := 0.0
    first := int64(0)
    firstRatio := 0.0
    fmt.Println("The mean proportion of zero digits in factorials up to the following are:")
    for n := int64(1); n <= 50000; n++  {
        fact.Mul(fact, big.NewInt(n))
        bytes  := []byte(fact.String())
        digits := len(bytes)
        zeros  := 0
        for _, b := range bytes {
            if b == '0' {
                zeros++
            }
        }
        sum += float64(zeros)/float64(digits)
        ratio := sum / float64(n)
        if n == 100 || n == 1000 || n == 10000 {
            fmt.Printf("%6s = %12.10f\n", rcu.Commatize(int(n)), ratio)
        }
        if first > 0 && ratio >= 0.16 {
            first = 0
            firstRatio = 0.0
        } else if first == 0 && ratio < 0.16 {
            first = n
            firstRatio = ratio
        }
    }
    fmt.Printf("%6s = %12.10f", rcu.Commatize(int(first)), firstRatio)
    fmt.Println(" (stays below 0.16 after this)")
    fmt.Printf("%6s = %12.10f\n", "50,000", sum / 50000)
}
