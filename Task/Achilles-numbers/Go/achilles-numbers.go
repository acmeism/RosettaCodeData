package main

import (
    "fmt"
    "math"
    "sort"
)

func totient(n int) int {
    tot := n
    i := 2
    for i*i <= n {
        if n%i == 0 {
            for n%i == 0 {
                n /= i
            }
            tot -= tot / i
        }
        if i == 2 {
            i = 1
        }
        i += 2
    }
    if n > 1 {
        tot -= tot / n
    }
    return tot
}

var pps = make(map[int]bool)

func getPerfectPowers(maxExp int) {
    upper := math.Pow(10, float64(maxExp))
    for i := 2; i <= int(math.Sqrt(upper)); i++ {
        fi := float64(i)
        p := fi
        for {
            p *= fi
            if p >= upper {
                break
            }
            pps[int(p)] = true
        }
    }
}

func getAchilles(minExp, maxExp int) map[int]bool {
    lower := math.Pow(10, float64(minExp))
    upper := math.Pow(10, float64(maxExp))
    achilles := make(map[int]bool)
    for b := 1; b <= int(math.Cbrt(upper)); b++ {
        b3 := b * b * b
        for a := 1; a <= int(math.Sqrt(upper)); a++ {
            p := b3 * a * a
            if p >= int(upper) {
                break
            }
            if p >= int(lower) {
                if _, ok := pps[p]; !ok {
                    achilles[p] = true
                }
            }
        }
    }
    return achilles
}

func main() {
    maxDigits := 15
    getPerfectPowers(maxDigits)
    achillesSet := getAchilles(1, 5) // enough for first 2 parts
    achilles := make([]int, len(achillesSet))
    i := 0
    for k := range achillesSet {
        achilles[i] = k
        i++
    }
    sort.Ints(achilles)

    fmt.Println("First 50 Achilles numbers:")
    for i = 0; i < 50; i++ {
        fmt.Printf("%4d ", achilles[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\nFirst 30 strong Achilles numbers:")
    var strongAchilles []int
    count := 0
    for n := 0; count < 30; n++ {
        tot := totient(achilles[n])
        if _, ok := achillesSet[tot]; ok {
            strongAchilles = append(strongAchilles, achilles[n])
            count++
        }
    }
    for i = 0; i < 30; i++ {
        fmt.Printf("%5d ", strongAchilles[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\nNumber of Achilles numbers with:")
    for d := 2; d <= maxDigits; d++ {
        ac := len(getAchilles(d-1, d))
        fmt.Printf("%2d digits: %d\n", d, ac)
    }
}
