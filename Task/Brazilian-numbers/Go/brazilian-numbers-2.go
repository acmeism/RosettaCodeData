package main

import (
    "fmt"
    "math"
    "time"
)

// flags
const (
    prMk int8 = 0   // prime
    sqMk      = 1   // prime square
    upMk      = 2   // non-prime
    brMk      = -2  // Brazilian prime
    excp      = 121 // the only Brazilian square prime
)

var (
    pow = 9
    max = 0
    ps  []int8
)

// typical sieve of Eratosthenes
func primeSieve(top int) {
    ps = make([]int8, top)
    i, j := 2, 4
    ps[j] = sqMk
    for j < top-2 {
        j += 2
        ps[j] = upMk
    }
    i, j = 3, 9
    ps[j] = sqMk
    for j < top-6 {
        j += 6
        ps[j] = upMk
    }
    i = 5
    for i*i < top {
        if ps[i] == prMk {
            j = (top - i) / i
            if (j & 1) == 0 {
                j--
            }
            for {
                if ps[j] == prMk {
                    ps[i*j] = upMk
                }
                j -= 2
                if j <= i {
                    break
                }
            }
            ps[i*i] = sqMk
        }
        for {
            i += 2
            if ps[i] == prMk {
                break
            }
        }
    }
}

// returns whether a number is Brazilian
func isBr(number int) bool {
    temp := ps[number]
    if temp < 0 {
        temp = -temp
    }
    return temp > sqMk
}

// shows the first few Brazilian numbers of several kinds
func firstFew(kind string, amt int) {
    fmt.Printf("\nThe first %d %sBrazilian numbers are:\n", amt, kind)
    i := 7
    for amt > 0 {
        if isBr(i) {
            amt--
            fmt.Printf("%d ", i)
        }
        switch kind {
        case "odd ":
            i += 2
        case "prime ":
            for {
                i += 2
                if ps[i] == brMk && i != excp {
                    break
                }
            }
        default:
            i++
        }
    }
    fmt.Println()
}

// expands a 111_X number into an integer
func expand(numberOfOnes, base int) int {
    res := 1
    for numberOfOnes > 1 {
        numberOfOnes--
        res = res*base + 1
    }
    if res > max || res < 0 {
        res = 0
    }
    return res
}

func toMs(d time.Duration) float64 {
    return float64(d) / 1e6
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
    start := time.Now()
    st0 := start
    p2 := pow << 1
    p10 := int(math.Pow10(pow))
    p, cnt := 10, 0
    max = p10 * p2 / (p2 - 1)
    primeSieve(max)
    fmt.Printf("Sieving took %.4f ms\n", toMs(time.Since(start)))
    start = time.Now()
    primes := make([]int, 7)
    n := 3
    for i := 0; i < len(primes); i++ {
        primes[i] = n
        for {
            n += 2
            if ps[n] == 0 {
                break
            }
        }
    }
    fmt.Println("\nChecking first few prime numbers of sequential ones:")
    fmt.Println("ones checked found")
    for _, i := range primes {
        fmt.Printf("%4d", i)
        cnt, n = 0, 2
        for {
            if (n-1)%i != 0 {
                br := expand(i, n)
                if br > 0 {
                    if ps[br] < upMk {
                        ps[br] = brMk
                        cnt++
                    }
                } else {
                    fmt.Printf("%8d%6d\n", n, cnt)
                    break
                }
            }
            n++
        }
    }
    ms := toMs(time.Since(start))
    fmt.Printf("Adding Brazilian primes to the sieve took %.4f ms\n", ms)
    start = time.Now()
    for _, s := range []string{"", "odd ", "prime "} {
        firstFew(s, 20)
    }
    fmt.Printf("\nRequired output took %.4f ms\n", toMs(time.Since(start)))
    fmt.Println("\nDecade count of Brazilian numbers:")
    n, cnt = 6, 0
    for {
        for cnt < p {
            n++
            if isBr(n) {
                cnt++
            }
        }
        ms = toMs(time.Since(start))
        fmt.Printf("%15sth is %-15s  time: %8.4f ms\n", commatize(cnt), commatize(n), ms)
        p *= 10
        if p > p10 {
            break
        }
    }
    fmt.Printf("\nTotal elapsed was %.4f ms\n", toMs(time.Since(st0)))
}
