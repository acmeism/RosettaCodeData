package main

import (
    "fmt"
    "math/rand"
    "strconv"
    "strings"
    "time"
)

func factorial(n int) int {
    fact := 1
    for i := 2; i <= n; i++ {
        fact *= i
    }
    return fact
}

func genFactBaseNums(size int, countOnly bool) ([][]int, int) {
    var results [][]int
    count := 0
    for n := 0; ; n++ {
        radix := 2
        var res []int = nil
        if !countOnly {
            res = make([]int, size)
        }
        k := n
        for k > 0 {
            div := k / radix
            rem := k % radix
            if !countOnly {
                if radix <= size+1 {
                    res[size-radix+1] = rem
                }
            }
            k = div
            radix++
        }
        if radix > size+2 {
            break
        }
        count++
        if !countOnly {
            results = append(results, res)
        }
    }
    return results, count
}

func mapToPerms(factNums [][]int) [][]int {
    var perms [][]int
    psize := len(factNums[0]) + 1
    start := make([]int, psize)
    for i := 0; i < psize; i++ {
        start[i] = i
    }
    for _, fn := range factNums {
        perm := make([]int, psize)
        copy(perm, start)
        for m := 0; m < len(fn); m++ {
            g := fn[m]
            if g == 0 {
                continue
            }
            first := m
            last := m + g
            for i := 1; i <= g; i++ {
                temp := perm[first]
                for j := first + 1; j <= last; j++ {
                    perm[j-1] = perm[j]
                }
                perm[last] = temp
            }
        }
        perms = append(perms, perm)
    }
    return perms
}

func join(is []int, sep string) string {
    ss := make([]string, len(is))
    for i := 0; i < len(is); i++ {
        ss[i] = strconv.Itoa(is[i])
    }
    return strings.Join(ss, sep)
}

func undot(s string) []int {
    ss := strings.Split(s, ".")
    is := make([]int, len(ss))
    for i := 0; i < len(ss); i++ {
        is[i], _ = strconv.Atoi(ss[i])
    }
    return is
}

func main() {
    rand.Seed(time.Now().UnixNano())

    // Recreate the table.
    factNums, _ := genFactBaseNums(3, false)
    perms := mapToPerms(factNums)
    for i, fn := range factNums {
        fmt.Printf("%v -> %v\n", join(fn, "."), join(perms[i], ""))
    }

    // Check that the number of perms generated is equal to 11! (this takes a while).
    _, count := genFactBaseNums(10, true)
    fmt.Println("\nPermutations generated =", count)
    fmt.Println("compared to 11! which  =", factorial(11))
    fmt.Println()

    // Generate shuffles for the 2 given 51 digit factorial base numbers.
    fbn51s := []string{
        "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
        "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1",
    }
    factNums = [][]int{undot(fbn51s[0]), undot(fbn51s[1])}
    perms = mapToPerms(factNums)
    shoe := []rune("A♠K♠Q♠J♠T♠9♠8♠7♠6♠5♠4♠3♠2♠A♥K♥Q♥J♥T♥9♥8♥7♥6♥5♥4♥3♥2♥A♦K♦Q♦J♦T♦9♦8♦7♦6♦5♦4♦3♦2♦A♣K♣Q♣J♣T♣9♣8♣7♣6♣5♣4♣3♣2♣")
    cards := make([]string, 52)
    for i := 0; i < 52; i++ {
        cards[i] = string(shoe[2*i : 2*i+2])
        if cards[i][0] == 'T' {
            cards[i] = "10" + cards[i][1:]
        }
    }
    for i, fbn51 := range fbn51s {
        fmt.Println(fbn51)
        for _, d := range perms[i] {
            fmt.Print(cards[d])
        }
        fmt.Println("\n")
    }

    // Create a random 51 digit factorial base number and produce a shuffle from that.
    fbn51 := make([]int, 51)
    for i := 0; i < 51; i++ {
        fbn51[i] = rand.Intn(52 - i)
    }
    fmt.Println(join(fbn51, "."))
    perms = mapToPerms([][]int{fbn51})
    for _, d := range perms[0] {
        fmt.Print(cards[d])
    }
    fmt.Println()
}
