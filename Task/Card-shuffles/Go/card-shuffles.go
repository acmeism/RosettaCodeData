package main

import (
    "fmt"
    "math/rand"
    "time"
)

func reverse(s []int) {
    for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
        s[i], s[j] = s[j], s[i]
    }
}

func riffle(deck []int, iterations int) []int {
    le := len(deck)
    pile := make([]int, le)
    copy(pile, deck)
    for i := 0; i < iterations; i++ {
        mid := le / 2
        tenpc := mid / 10
        // choose a random number within 10% of midpoint
        cut := mid - tenpc + rand.Intn(2*tenpc+1)
        // split deck into two at cut point
        deck1 := make([]int, cut)
        deck2 := make([]int, le-cut)
        copy(deck1, pile[:cut])
        copy(deck2, pile[cut:])
        pile = pile[:0]
        fromTop := rand.Intn(2) // choose to draw from top (1) or bottom (0)
        for len(deck1) > 0 && len(deck2) > 0 {
            if fromTop == 1 {
                el1 := deck1[0]
                deck1 = deck1[1:]
                el2 := deck2[0]
                deck2 = deck2[1:]
                pile = append(pile, el1, el2)
            } else {
                el1 := deck1[len(deck1)-1]
                deck1 = deck1[:len(deck1)-1]
                el2 := deck2[len(deck2)-1]
                deck2 = deck2[:len(deck2)-1]
                pile = append(pile, el1, el2)
            }
        }
        // add any remaining cards to the pile and reverse it
        if len(deck1) > 0 {
            pile = append(pile, deck1...)
        } else if len(deck2) > 0 {
            pile = append(pile, deck2...)
        }
        reverse(pile) // as pile is upside down
    }
    return pile
}

func overhand(deck []int, iterations int) []int {
    le := len(deck)
    pile := make([]int, le)
    copy(pile, deck)
    pile2 := make([]int, 0)
    twentypc := le / 5
    for i := 0; i < iterations; i++ {
        for len(pile) > 0 {
            cards := 1 + rand.Intn(twentypc)
            if cards > len(pile) {
                cards = len(pile)
            }
            temp := make([]int, cards)
            copy(temp, pile[:cards])
            pile2 = append(temp, pile2...)
            pile = pile[cards:]
        }
        pile = append(pile, pile2...)
        pile2 = pile2[:0]
    }
    return pile
}

func main() {
    rand.Seed(time.Now().UnixNano())
    fmt.Println("Starting deck:")
    deck := make([]int, 20)
    for i := 0; i < 20; i++ {
        deck[i] = i + 1
    }
    fmt.Println(deck)
    const iterations = 10
    fmt.Println("\nRiffle shuffle with", iterations, "iterations:")
    fmt.Println(riffle(deck, iterations))
    fmt.Println("\nOverhand shuffle with", iterations, "iterations:")
    fmt.Println(overhand(deck, iterations))
    fmt.Println("\nStandard library shuffle with 1 iteration:")
    rand.Shuffle(len(deck), func(i, j int) {
        deck[i], deck[j] = deck[j], deck[i] // shuffles deck in place
    })
    fmt.Println(deck)
}
