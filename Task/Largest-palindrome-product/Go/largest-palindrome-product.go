package main

import "fmt"

func reverse(n uint64) uint64 {
    r := uint64(0)
    for n > 0 {
        r = n%10 + r*10
        n /= 10
    }
    return r
}

func main() {
    pow := uint64(10)
nextN:
    for n := 2; n < 10; n++ {
        low := pow * 9
        pow *= 10
        high := pow - 1
        fmt.Printf("Largest palindromic product of two %d-digit integers: ", n)
        for i := high; i >= low; i-- {
            j := reverse(i)
            p := i*pow + j
            // k can't be even nor end in 5 to produce a product ending in 9
            for k := high; k > low; k -= 2 {
                if k % 10 == 5 {
                    continue
                }
                l := p / k
                if l > high {
                    break
                }
                if p%k == 0 {
                    fmt.Printf("%d x %d = %d\n", k, l, p)
                    continue nextN
                }
            }
        }
    }
}
