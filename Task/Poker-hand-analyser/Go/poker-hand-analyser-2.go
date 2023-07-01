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

func isStraight(cards []card, jokers int) bool {
    sorted := make([]card, 5)
    copy(sorted, cards)
    sort.Slice(sorted, func(i, j int) bool {
        return sorted[i].face < sorted[j].face
    })
    switch jokers {
    case 0:
        switch {
        case sorted[0].face+4 == sorted[4].face,
            sorted[4].face == 14 && sorted[3].face == 5:
            return true
        default:
            return false
        }
    case 1:
        switch {
        case sorted[0].face+3 == sorted[3].face,
            sorted[0].face+4 == sorted[3].face,
            sorted[3].face == 14 && sorted[2].face == 4,
            sorted[3].face == 14 && sorted[2].face == 5:
            return true
        default:
            return false
        }
    default:
        switch {
        case sorted[0].face+2 == sorted[2].face,
            sorted[0].face+3 == sorted[2].face,
            sorted[0].face+4 == sorted[2].face,
            sorted[2].face == 14 && sorted[1].face == 3,
            sorted[2].face == 14 && sorted[1].face == 4,
            sorted[2].face == 14 && sorted[1].face == 5:
            return true
        default:
            return false
        }
    }
}

func isFlush(cards []card) bool {
    sorted := make([]card, 5)
    copy(sorted, cards)
    sort.Slice(sorted, func(i, j int) bool {
        return sorted[i].face < sorted[j].face
    })
    suit := sorted[0].suit
    for i := 1; i < 5; i++ {
        if sorted[i].suit != suit && sorted[i].suit != 'j' {
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
    var jokers = 0

    for _, s := range split {
        if len(s) != 4 {
            return "invalid"
        }
        cp := []rune(s)[0]
        var cd card
        switch {
        case cp == 0x1f0a1:
            cd = card{14, 's'}
        case cp == 0x1f0b1:
            cd = card{14, 'h'}
        case cp == 0x1f0c1:
            cd = card{14, 'd'}
        case cp == 0x1f0d1:
            cd = card{14, 'c'}
        case cp == 0x1f0cf:
            jokers++
            cd = card{15, 'j'} // black joker
        case cp == 0x1f0df:
            jokers++
            cd = card{16, 'j'} // white joker
        case cp >= 0x1f0a2 && cp <= 0x1f0ab:
            cd = card{byte(cp - 0x1f0a0), 's'}
        case cp >= 0x1f0ad && cp <= 0x1f0ae:
            cd = card{byte(cp - 0x1f0a1), 's'}
        case cp >= 0x1f0b2 && cp <= 0x1f0bb:
            cd = card{byte(cp - 0x1f0b0), 'h'}
        case cp >= 0x1f0bd && cp <= 0x1f0be:
            cd = card{byte(cp - 0x1f0b1), 'h'}
        case cp >= 0x1f0c2 && cp <= 0x1f0cb:
            cd = card{byte(cp - 0x1f0c0), 'd'}
        case cp >= 0x1f0cd && cp <= 0x1f0ce:
            cd = card{byte(cp - 0x1f0c1), 'd'}
        case cp >= 0x1f0d2 && cp <= 0x1f0db:
            cd = card{byte(cp - 0x1f0d0), 'c'}
        case cp >= 0x1f0dd && cp <= 0x1f0de:
            cd = card{byte(cp - 0x1f0d1), 'c'}
        default:
            cd = card{0, 'j'} // invalid
        }
        if cd.face == 0 {
            return "invalid"
        }
        cards = append(cards, cd)
    }

    groups := make(map[byte][]card)
    for _, c := range cards {
        groups[c.face] = append(groups[c.face], c)
    }

    switch len(groups) {
    case 2:
        for _, group := range groups {
            if len(group) == 4 {
                switch jokers {
                case 0:
                    return "four-of-a-kind"
                default:
                    return "five-of-a-kind"
                }
            }
        }
        return "full-house"
    case 3:
        for _, group := range groups {
            if len(group) == 3 {
                switch jokers {
                case 0:
                    return "three-of-a-kind"
                case 1:
                    return "four-of-a-kind"
                default:
                    return "five-of-a-kind"
                }
            }
        }
        if jokers == 0 {
            return "two-pair"
        }
        return "full-house"
    case 4:
        switch jokers {
        case 0:
            return "one-pair"
        case 1:
            return "three-of-a-kind"
        default:
            return "four-of-a-kind"
        }
    default:
        flush := isFlush(cards)
        straight := isStraight(cards, jokers)
        switch {
        case flush && straight:
            return "straight-flush"
        case flush:
            return "flush"
        case straight:
            return "straight"
        default:
            if jokers == 0 {
                return "high-card"
            } else {
                return "one-pair"
            }
        }
    }
}

func main() {
    hands := [...]string{
        "🃏 🃂 🂢 🂮 🃍",
        "🃏 🂵 🃇 🂨 🃉",
        "🃏 🃂 🂣 🂤 🂥",
        "🃏 🂳 🃂 🂣 🃃",
        "🃏 🂷 🃂 🂣 🃃",
        "🃏 🂷 🃇 🂧 🃗",
        "🃏 🂻 🂽 🂾 🂱",
        "🃏 🃔 🃞 🃅 🂪",
        "🃏 🃞 🃗 🃖 🃔",
        "🃏 🃂 🃟 🂤 🂥",
        "🃏 🃍 🃟 🂡 🂪",
        "🃏 🃍 🃟 🃁 🃊",
        "🃏 🃂 🂢 🃟 🃍",
        "🃏 🃂 🂢 🃍 🃍",
        "🃂 🃞 🃍 🃁 🃊",
    }
    for _, hand := range hands {
        fmt.Printf("%s: %s\n", hand, analyzeHand(hand))
    }
}
