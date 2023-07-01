package main

import (
    "fmt"
    "sort"
    "strings"
)

type card struct {
    face byte
    suit byte
}

const faces = "23456789tjqka"
const suits = "shdc"

func isStraight(cards []card) bool {
    sorted := make([]card, 5)
    copy(sorted, cards)
    sort.Slice(sorted, func(i, j int) bool {
        return sorted[i].face < sorted[j].face
    })
    if sorted[0].face+4 == sorted[4].face {
        return true
    }
    if sorted[4].face == 14 && sorted[0].face == 2 && sorted[3].face == 5 {
        return true
    }
    return false
}

func isFlush(cards []card) bool {
    suit := cards[0].suit
    for i := 1; i < 5; i++ {
        if cards[i].suit != suit {
            return false
        }
    }
    return true
}

func analyzeHand(hand string) string {
    temp := strings.Fields(strings.ToLower(hand))
    splitSet := make(map[string]bool)
    var split []string
    for _, s := range temp {
        if !splitSet[s] {
            splitSet[s] = true
            split = append(split, s)
        }
    }
    if len(split) != 5 {
        return "invalid"
    }
    var cards []card

    for _, s := range split {
        if len(s) != 2 {
            return "invalid"
        }
        fIndex := strings.IndexByte(faces, s[0])
        if fIndex == -1 {
            return "invalid"
        }
        sIndex := strings.IndexByte(suits, s[1])
        if sIndex == -1 {
            return "invalid"
        }
        cards = append(cards, card{byte(fIndex + 2), s[1]})
    }

    groups := make(map[byte][]card)
    for _, c := range cards {
        groups[c.face] = append(groups[c.face], c)
    }

    switch len(groups) {
    case 2:
        for _, group := range groups {
            if len(group) == 4 {
                return "four-of-a-kind"
            }
        }
        return "full-house"
    case 3:
        for _, group := range groups {
            if len(group) == 3 {
                return "three-of-a-kind"
            }
        }
        return "two-pair"
    case 4:
        return "one-pair"
    default:
        flush := isFlush(cards)
        straight := isStraight(cards)
        switch {
        case flush && straight:
            return "straight-flush"
        case flush:
            return "flush"
        case straight:
            return "straight"
        default:
            return "high-card"
        }
    }
}

func main() {
    hands := [...]string{
        "2h 2d 2c kc qd",
        "2h 5h 7d 8c 9s",
        "ah 2d 3c 4c 5d",
        "2h 3h 2d 3c 3d",
        "2h 7h 2d 3c 3d",
        "2h 7h 7d 7c 7s",
        "th jh qh kh ah",
        "4h 4s ks 5d ts",
        "qc tc 7c 6c 4c",
        "ah ah 7c 6c 4c",
    }
    for _, hand := range hands {
        fmt.Printf("%s: %s\n", hand, analyzeHand(hand))
    }
}
