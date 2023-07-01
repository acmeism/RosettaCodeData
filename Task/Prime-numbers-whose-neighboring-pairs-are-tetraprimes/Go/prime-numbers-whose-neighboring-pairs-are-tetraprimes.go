package main

import (
    "fmt"
    "rcu"
    "sort"
)

const LIMIT = int(1e7)
var primes = rcu.Primes(LIMIT)

func isTetraPrime(n int) bool {
    count := 0;
    prevFact := 1
    for _, p := range primes {
        limit := p * p
        if count == 0 {
            limit *= limit
        } else if count == 1 {
            limit *= p
        }
        if limit <= n {
            for n % p == 0 {
                if count == 4 || p == prevFact {
                    return false
                }
                count++
                n /= p
                prevFact = p
            }
        } else {
            break
        }
    }
    if n > 1 {
        if count == 4 || n == prevFact {
            return false
        }
        count++
    }
    return count == 4
}

// Note that 'gaps' will only contain even numbers here.
func median(gaps []int) int {
    le := len(gaps)
    m := le / 2
    if le&1 == 1 {
        return gaps[m]
    }
    return (gaps[m] + gaps[m-1]) / 2
}

func main() {
    highest5 := primes[sort.SearchInts(primes, int(1e5))-1]
    highest6 := primes[sort.SearchInts(primes, int(1e6))-1]
    highest7 := primes[len(primes)-1]
    var tetras1, tetras2 []int
    sevens1, sevens2 := 0, 0
    j := 100_000
    for _, p := range primes {
        // process even numbers first as likely to have most factors
        if isTetraPrime(p-1) && isTetraPrime(p-2) {
            tetras1 = append(tetras1, p)
            if (p-1)%7 == 0 || (p-2)%7 == 0 {
                sevens1++
            }
        }

        if isTetraPrime(p+1) && isTetraPrime(p+2) {
            tetras2 = append(tetras2, p)
            if (p+1)%7 == 0 || (p+2)%7 == 0 {
                sevens2++
            }
        }

        if p == highest5 || p == highest6 || p == highest7 {
            for i := 0; i < 2; i++ {
                tetras := tetras1
                if i == 1 {
                    tetras = tetras2
                }
                sevens := sevens1
                if i == 1 {
                    sevens = sevens2
                }
                c := len(tetras)
                t := "preceding"
                if i == 1 {
                    t = "following"
                }
                fmt.Printf("Found %s primes under %s whose %s neighboring pair are tetraprimes", rcu.Commatize(c), rcu.Commatize(j), t)
                if p == highest5 {
                    fmt.Printf(":\n")
                    for k := 0; k < c; k++ {
                        fmt.Printf("%5d ", tetras[k])
                        if (k+1)%10 == 0 {
                            fmt.Println()
                        }
                    }
                    fmt.Println()
                }
                fmt.Println()
                fmt.Printf("of which %s have a neighboring pair one of whose factors is 7.\n\n", rcu.Commatize(sevens))
                gaps := make([]int, c-1)
                for k := 0; k < c-1; k++ {
                    gaps[k] = tetras[k+1] - tetras[k]
                }
                sort.Ints(gaps)
                mins := rcu.Commatize(gaps[0])
                maxs := rcu.Commatize(gaps[c-2])
                meds := rcu.Commatize(median(gaps))
                cs := rcu.Commatize(c)
                fmt.Printf("Minimum gap between those %s primes : %s\n", cs, mins)
                fmt.Printf("Median  gap between those %s primes : %s\n", cs, meds)
                fmt.Printf("Maximum gap between those %s primes : %s\n", cs, maxs)
                fmt.Println()
            }
            j *= 10
        }
    }
}
