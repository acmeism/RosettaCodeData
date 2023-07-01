package main

import (
    "fmt"
    "math/rand"
    "time"
)

var suits = []string{"♣", "♦", "♥", "♠"}
var faces = []string{"2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"}
var cards = make([]string, 52)
var ranks = make([]int, 52)

func init() {
    for i := 0; i < 52; i++ {
        cards[i] = fmt.Sprintf("%s%s", faces[i%13], suits[i/13])
        ranks[i] = i % 13
    }
}

func war() {
    deck := make([]int, 52)
    for i := 0; i < 52; i++ {
        deck[i] = i
    }
    rand.Shuffle(52, func(i, j int) {
        deck[i], deck[j] = deck[j], deck[i]
    })
    hand1 := make([]int, 26, 52)
    hand2 := make([]int, 26, 52)
    for i := 0; i < 26; i++ {
        hand1[25-i] = deck[2*i]
        hand2[25-i] = deck[2*i+1]
    }
    for len(hand1) > 0 && len(hand2) > 0 {
        card1 := hand1[0]
        copy(hand1[0:], hand1[1:])
        hand1[len(hand1)-1] = 0
        hand1 = hand1[0 : len(hand1)-1]
        card2 := hand2[0]
        copy(hand2[0:], hand2[1:])
        hand2[len(hand2)-1] = 0
        hand2 = hand2[0 : len(hand2)-1]
        played1 := []int{card1}
        played2 := []int{card2}
        numPlayed := 2
        for {
            fmt.Printf("%s\t%s\t", cards[card1], cards[card2])
            if ranks[card1] > ranks[card2] {
                hand1 = append(hand1, played1...)
                hand1 = append(hand1, played2...)
                fmt.Printf("Player 1 takes the %d cards. Now has %d.\n", numPlayed, len(hand1))
                break
            } else if ranks[card1] < ranks[card2] {
                hand2 = append(hand2, played2...)
                hand2 = append(hand2, played1...)
                fmt.Printf("Player 2 takes the %d cards. Now has %d.\n", numPlayed, len(hand2))
                break
            } else {
                fmt.Println("War!")
                if len(hand1) < 2 {
                    fmt.Println("Player 1 has insufficient cards left.")
                    hand2 = append(hand2, played2...)
                    hand2 = append(hand2, played1...)
                    hand2 = append(hand2, hand1...)
                    hand1 = hand1[0:0]
                    break
                }
                if len(hand2) < 2 {
                    fmt.Println("Player 2 has insufficient cards left.")
                    hand1 = append(hand1, played1...)
                    hand1 = append(hand1, played2...)
                    hand1 = append(hand1, hand2...)
                    hand2 = hand2[0:0]
                    break
                }
                fdCard1 := hand1[0] // face down card
                card1 = hand1[1]    // face up card
                copy(hand1[0:], hand1[2:])
                hand1[len(hand1)-1] = 0
                hand1[len(hand1)-2] = 0
                hand1 = hand1[0 : len(hand1)-2]
                played1 = append(played1, fdCard1, card1)
                fdCard2 := hand2[0] // face down card
                card2 = hand2[1]    // face up card
                copy(hand2[0:], hand2[2:])
                hand2[len(hand2)-1] = 0
                hand2[len(hand2)-2] = 0
                hand2 = hand2[0 : len(hand2)-2]
                played2 = append(played2, fdCard2, card2)
                numPlayed += 4
                fmt.Println("? \t? \tFace down cards.")
            }
        }
    }
    if len(hand1) == 52 {
        fmt.Println("Player 1 wins the game!")
    } else {
        fmt.Println("Player 2 wins the game!")
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    war()
}
