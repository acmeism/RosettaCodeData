package main

import (
    "fmt"
    "log"
    "strings"
)

var glyphs = []rune("♜♞♝♛♚♖♘♗♕♔")
var names = map[rune]string{'R': "rook", 'N': "knight", 'B': "bishop", 'Q': "queen", 'K': "king"}
var g2lMap = map[rune]string{
    '♜': "R", '♞': "N", '♝': "B", '♛': "Q", '♚': "K",
    '♖': "R", '♘': "N", '♗': "B", '♕': "Q", '♔': "K",
}

var ntable = map[string]int{"01": 0, "02": 1, "03": 2, "04": 3, "12": 4, "13": 5, "14": 6, "23": 7, "24": 8, "34": 9}

func g2l(pieces string) string {
    lets := ""
    for _, p := range pieces {
        lets += g2lMap[p]
    }
    return lets
}

func spid(pieces string) int {
    pieces = g2l(pieces) // convert glyphs to letters

    /* check for errors */
    if len(pieces) != 8 {
        log.Fatal("There must be exactly 8 pieces.")
    }
    for _, one := range "KQ" {
        count := 0
        for _, p := range pieces {
            if p == one {
                count++
            }
        }
        if count != 1 {
            log.Fatalf("There must be one %s.", names[one])
        }
    }
    for _, two := range "RNB" {
        count := 0
        for _, p := range pieces {
            if p == two {
                count++
            }
        }
        if count != 2 {
            log.Fatalf("There must be two %s.", names[two])
        }
    }
    r1 := strings.Index(pieces, "R")
    r2 := strings.Index(pieces[r1+1:], "R") + r1 + 1
    k := strings.Index(pieces, "K")
    if k < r1 || k > r2 {
        log.Fatal("The king must be between the rooks.")
    }
    b1 := strings.Index(pieces, "B")
    b2 := strings.Index(pieces[b1+1:], "B") + b1 + 1
    if (b2-b1)%2 == 0 {
        log.Fatal("The bishops must be on opposite color squares.")
    }

    /* compute SP_ID */
    piecesN := strings.ReplaceAll(pieces, "Q", "")
    piecesN = strings.ReplaceAll(piecesN, "B", "")
    n1 := strings.Index(piecesN, "N")
    n2 := strings.Index(piecesN[n1+1:], "N") + n1 + 1
    np := fmt.Sprintf("%d%d", n1, n2)
    N := ntable[np]

    piecesQ := strings.ReplaceAll(pieces, "B", "")
    Q := strings.Index(piecesQ, "Q")

    D := strings.Index("0246", fmt.Sprintf("%d", b1))
    L := strings.Index("1357", fmt.Sprintf("%d", b2))
    if D == -1 {
        D = strings.Index("0246", fmt.Sprintf("%d", b2))
        L = strings.Index("1357", fmt.Sprintf("%d", b1))
    }

    return 96*N + 16*Q + 4*D + L
}

func main() {
    for _, pieces := range []string{"♕♘♖♗♗♘♔♖", "♖♘♗♕♔♗♘♖", "♖♕♘♗♗♔♖♘", "♖♘♕♗♗♔♖♘"} {
        fmt.Printf("%s or %s has SP-ID of %d\n", pieces, g2l(pieces), spid(pieces))
    }
}
