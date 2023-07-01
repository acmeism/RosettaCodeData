package main

import (
    "fmt"
    "math/big"
    "math/rand"
    "strings"
    "time"
)

// Prepend base 10 representation with an "a" and you get a base 11 number.
// Unfortunately base 11 is a little awkward with big.Int, so just treat it
// as base 16.
func rank(l []big.Int) (r big.Int, err error) {
    if len(l) == 0 {
        return
    }
    s := make([]string, len(l))
    for i, n := range l {
        ns := n.String()
        if ns[0] == '-' {
            return r, fmt.Errorf("negative integers not mapped")
        }
        s[i] = "a" + ns
    }
    r.SetString(strings.Join(s, ""), 16)
    return
}

// Split the base 16 representation at "a", recover the base 10 numbers.
func unrank(r big.Int) ([]big.Int, error) {
    s16 := fmt.Sprintf("%x", &r)
    switch {
    case s16 == "0":
        return nil, nil // empty list
    case s16[0] != 'a':
        return nil, fmt.Errorf("unrank not bijective")
    }
    s := strings.Split(s16[1:], "a")
    l := make([]big.Int, len(s))
    for i, s1 := range s {
        if _, ok := l[i].SetString(s1, 10); !ok {
            return nil, fmt.Errorf("unrank not bijective")
        }
    }
    return l, nil
}

func main() {
    // show empty list
    var l []big.Int
    r, _ := rank(l)
    u, _ := unrank(r)
    fmt.Println("Empty list:", l, &r, u)

    // show random list
    l = random()
    r, _ = rank(l)
    u, _ = unrank(r)
    fmt.Println("\nList:")
    for _, n := range l {
        fmt.Println("  ", &n)
    }
    fmt.Println("Rank:")
    fmt.Println("  ", &r)
    fmt.Println("Unranked:")
    for _, n := range u {
        fmt.Println("  ", &n)
    }

    // show error with list containing negative
    var n big.Int
    n.SetInt64(-5)
    _, err := rank([]big.Int{n})
    fmt.Println("\nList element:", &n, err)

    // show technique is not bijective
    n.SetInt64(1)
    _, err = unrank(n)
    fmt.Println("Rank:", &n, err)
}

// returns 0 to 5 numbers in the range 1 to 2^100
func random() []big.Int {
    r := rand.New(rand.NewSource(time.Now().Unix()))
    l := make([]big.Int, r.Intn(6))
    one := big.NewInt(1)
    max := new(big.Int).Lsh(one, 100)
    for i := range l {
        l[i].Add(one, l[i].Rand(r, max))
    }
    return l
}
