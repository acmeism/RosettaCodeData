package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "strings"
)

// OK for 'small' numbers.
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

func repunit(n int) *big.Int {
    ones := strings.Repeat("1", n)
    b, _ := new(big.Int).SetString(ones, 10)
    return b
}

var circs = []int{}

// binary search is overkill for a small number of elements
func alreadyFound(n int) bool {
    for _, i := range circs {
        if i == n {
            return true
        }
    }
    return false
}

func isCircular(n int) bool {
    nn := n
    pow := 1 // will eventually contain 10 ^ d where d is number of digits in n
    for nn > 0 {
        pow *= 10
        nn /= 10
    }
    nn = n
    for {
        nn *= 10
        f := nn / pow // first digit
        nn += f * (1 - pow)
        if alreadyFound(nn) {
            return false
        }
        if nn == n {
            break
        }
        if !isPrime(nn) {
            return false
        }
    }
    return true
}

func main() {
    fmt.Println("The first 19 circular primes are:")
    digits := [4]int{1, 3, 7, 9}
    q := []int{1, 2, 3, 5, 7, 9}  // queue the numbers to be examined
    fq := []int{1, 2, 3, 5, 7, 9} // also queue the corresponding first digits
    count := 0
    for {
        f := q[0]   // peek first element
        fd := fq[0] // peek first digit
        if isPrime(f) && isCircular(f) {
            circs = append(circs, f)
            count++
            if count == 19 {
                break
            }
        }
        copy(q, q[1:])   // pop first element
        q = q[:len(q)-1] // reduce length by 1
        copy(fq, fq[1:]) // ditto for first digit queue
        fq = fq[:len(fq)-1]
        if f == 2 || f == 5 { // if digits > 1 can't contain a 2 or 5
            continue
        }
        // add numbers with one more digit to queue
        // only numbers whose last digit >= first digit need be added
        for _, d := range digits {
            if d >= fd {
                q = append(q, f*10+d)
                fq = append(fq, fd)
            }
        }
    }
    fmt.Println(circs)
    fmt.Println("\nThe next 4 circular primes, in repunit format, are:")
    count = 0
    var rus []string
    for i := 7; count < 4; i++ {
        if repunit(i).ProbablyPrime(10) {
            count++
            rus = append(rus, fmt.Sprintf("R(%d)", i))
        }
    }
    fmt.Println(rus)
    fmt.Println("\nThe following repunits are probably circular primes:")
    for _, i := range []int{5003, 9887, 15073, 25031, 35317, 49081} {
        fmt.Printf("R(%-5d) : %t\n", i, repunit(i).ProbablyPrime(10))
    }
}
