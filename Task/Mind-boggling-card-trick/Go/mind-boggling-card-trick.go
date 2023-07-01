package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    // Create pack, half red, half black and shuffle it.
    var pack [52]byte
    for i := 0; i < 26; i++ {
        pack[i] = 'R'
        pack[26+i] = 'B'
    }
    rand.Seed(time.Now().UnixNano())
    rand.Shuffle(52, func(i, j int) {
        pack[i], pack[j] = pack[j], pack[i]
    })

    // Deal from pack into 3 stacks.
    var red, black, discard []byte
    for i := 0; i < 51; i += 2 {
        switch pack[i] {
        case 'B':
            black = append(black, pack[i+1])
        case 'R':
            red = append(red, pack[i+1])
        }
        discard = append(discard, pack[i])
    }
    lr, lb, ld := len(red), len(black), len(discard)
    fmt.Println("After dealing the cards the state of the stacks is:")
    fmt.Printf("  Red    : %2d cards -> %c\n", lr, red)
    fmt.Printf("  Black  : %2d cards -> %c\n", lb, black)
    fmt.Printf("  Discard: %2d cards -> %c\n", ld, discard)

    // Swap the same, random, number of cards between the red and black stacks.
    min := lr
    if lb < min {
        min = lb
    }
    n := 1 + rand.Intn(min)
    rp := rand.Perm(lr)[:n]
    bp := rand.Perm(lb)[:n]
    fmt.Printf("\n%d card(s) are to be swapped.\n\n", n)
    fmt.Println("The respective zero-based indices of the cards(s) to be swapped are:")
    fmt.Printf("  Red    : %2d\n", rp)
    fmt.Printf("  Black  : %2d\n", bp)
    for i := 0; i < n; i++ {
        red[rp[i]], black[bp[i]] = black[bp[i]], red[rp[i]]
    }
    fmt.Println("\nAfter swapping, the state of the red and black stacks is:")
    fmt.Printf("  Red    : %c\n", red)
    fmt.Printf("  Black  : %c\n", black)

    // Check that the number of black cards in the black stack equals
    // the number of red cards in the red stack.
    rcount, bcount := 0, 0
    for _, c := range red {
        if c == 'R' {
            rcount++
        }
    }
    for _, c := range black {
        if c == 'B' {
            bcount++
        }
    }

    fmt.Println("\nThe number of red cards in the red stack     =", rcount)
    fmt.Println("The number of black cards in the black stack =", bcount)
    if rcount == bcount {
        fmt.Println("So the asssertion is correct!")
    } else {
        fmt.Println("So the asssertion is incorrect!")
    }
}
