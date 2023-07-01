package main

import (
    "fmt"
    "math/big"
)

type B2357 []byte

var bi = new(big.Int)

func isSPDSPrime(b B2357) bool {
    bi.SetString(string(b), 10)
    return bi.ProbablyPrime(0) // 100% accurate up to 2 ^ 64
}

func listSPDSPrimes(startFrom B2357, countFrom, countTo uint64, printOne bool) B2357 {
    count := countFrom
    n := startFrom
    for {
        if isSPDSPrime(n) {
            count++
            if !printOne {
                fmt.Printf("%2d. %s\n", count, string(n))
            }
            if count == countTo {
                if printOne {
                    fmt.Println(string(n))
                }
                return n
            }
        }
        if printOne {
            n = n.AddTwo()
        } else {
            n = n.AddOne()
        }
    }
}

func incDigit(digit byte) byte {
    switch digit {
    case '2':
        return '3'
    case '3':
        return '5'
    case '5':
        return '7'
    default:
        return '9' // say
    }
}

func (b B2357) AddOne() B2357 {
    le := len(b)
    b[le-1] = incDigit(b[le-1])
    for i := le - 1; i >= 0; i-- {
        if b[i] < '9' {
            break
        } else if i > 0 {
            b[i] = '2'
            b[i-1] = incDigit(b[i-1])
        } else {
            b[0] = '2'
            nb := make(B2357, le+1)
            copy(nb[1:], b)
            nb[0] = '2'
            return nb
        }
    }
    return b
}

func (b B2357) AddTwo() B2357 {
    return b.AddOne().AddOne()
}

func main() {
    fmt.Println("The first 25 terms of the Smarandache prime-digital sequence are:")
    n := listSPDSPrimes(B2357{'2'}, 0, 4, false)
    n = listSPDSPrimes(n.AddOne(), 4, 25, false)
    fmt.Println("\nHigher terms:")
    indices := []uint64{25, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000}
    for i := 1; i < len(indices); i++ {
        fmt.Printf("%6d. ", indices[i])
        n = listSPDSPrimes(n.AddTwo(), indices[i-1], indices[i], true)
    }
}
