package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

type playfairOption int

const (
    noQ playfairOption = iota
    iEqualsJ
)

type playfair struct {
    keyword string
    pfo     playfairOption
    table   [5][5]byte
}

func (p *playfair) init() {
    // Build table.
    var used [26]bool // all elements false
    if p.pfo == noQ {
        used[16] = true // Q used
    } else {
        used[9] = true // J used
    }
    alphabet := strings.ToUpper(p.keyword) + "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i, j, k := 0, 0, 0; k < len(alphabet); k++ {
        c := alphabet[k]
        if c < 'A' || c > 'Z' {
            continue
        }
        d := int(c - 65)
        if !used[d] {
            p.table[i][j] = c
            used[d] = true
            j++
            if j == 5 {
                i++
                if i == 5 {
                    break // table has been filled
                }
                j = 0
            }
        }
    }
}

func (p *playfair) getCleanText(plainText string) string {
    // Ensure everything is upper case.
    plainText = strings.ToUpper(plainText)
    // Get rid of any non-letters and insert X between duplicate letters.
    var cleanText strings.Builder
    // Safe to assume null byte won't be present in plainText.
    prevByte := byte('\000')
    for i := 0; i < len(plainText); i++ {
        nextByte := plainText[i]
        // It appears that Q should be omitted altogether if NO_Q option is specified;
        // we assume so anyway.
        if nextByte < 'A' || nextByte > 'Z' || (nextByte == 'Q' && p.pfo == noQ) {
            continue
        }
        // If iEqualsJ option specified, replace J with I.
        if nextByte == 'J' && p.pfo == iEqualsJ {
            nextByte = 'I'
        }
        if nextByte != prevByte {
            cleanText.WriteByte(nextByte)
        } else {
            cleanText.WriteByte('X')
            cleanText.WriteByte(nextByte)
        }
        prevByte = nextByte
    }
    l := cleanText.Len()
    if l%2 == 1 {
        // Dangling letter at end so add another letter to complete digram.
        if cleanText.String()[l-1] != 'X' {
            cleanText.WriteByte('X')
        } else {
            cleanText.WriteByte('Z')
        }
    }
    return cleanText.String()
}

func (p *playfair) findByte(c byte) (int, int) {
    for i := 0; i < 5; i++ {
        for j := 0; j < 5; j++ {
            if p.table[i][j] == c {
                return i, j
            }
        }
    }
    return -1, -1
}

func (p *playfair) encode(plainText string) string {
    cleanText := p.getCleanText(plainText)
    var cipherText strings.Builder
    l := len(cleanText)
    for i := 0; i < l; i += 2 {
        row1, col1 := p.findByte(cleanText[i])
        row2, col2 := p.findByte(cleanText[i+1])
        switch {
        case row1 == row2:
            cipherText.WriteByte(p.table[row1][(col1+1)%5])
            cipherText.WriteByte(p.table[row2][(col2+1)%5])
        case col1 == col2:
            cipherText.WriteByte(p.table[(row1+1)%5][col1])
            cipherText.WriteByte(p.table[(row2+1)%5][col2])
        default:
            cipherText.WriteByte(p.table[row1][col2])
            cipherText.WriteByte(p.table[row2][col1])
        }
        if i < l-1 {
            cipherText.WriteByte(' ')
        }
    }
    return cipherText.String()
}

func (p *playfair) decode(cipherText string) string {
    var decodedText strings.Builder
    l := len(cipherText)
    // cipherText will include spaces so we need to skip them.
    for i := 0; i < l; i += 3 {
        row1, col1 := p.findByte(cipherText[i])
        row2, col2 := p.findByte(cipherText[i+1])
        switch {
        case row1 == row2:
            temp := 4
            if col1 > 0 {
                temp = col1 - 1
            }
            decodedText.WriteByte(p.table[row1][temp])
            temp = 4
            if col2 > 0 {
                temp = col2 - 1
            }
            decodedText.WriteByte(p.table[row2][temp])
        case col1 == col2:
            temp := 4
            if row1 > 0 {
                temp = row1 - 1
            }
            decodedText.WriteByte(p.table[temp][col1])
            temp = 4
            if row2 > 0 {
                temp = row2 - 1
            }
            decodedText.WriteByte(p.table[temp][col2])
        default:
            decodedText.WriteByte(p.table[row1][col2])
            decodedText.WriteByte(p.table[row2][col1])
        }
        if i < l-1 {
            decodedText.WriteByte(' ')
        }
    }
    return decodedText.String()
}

func (p *playfair) printTable() {
    fmt.Println("The table to be used is :\n")
    for i := 0; i < 5; i++ {
        for j := 0; j < 5; j++ {
            fmt.Printf("%c ", p.table[i][j])
        }
        fmt.Println()
    }
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    fmt.Print("Enter Playfair keyword : ")
    scanner.Scan()
    keyword := scanner.Text()
    var ignoreQ string
    for ignoreQ != "y" && ignoreQ != "n" {
        fmt.Print("Ignore Q when building table  y/n : ")
        scanner.Scan()
        ignoreQ = strings.ToLower(scanner.Text())
    }
    pfo := noQ
    if ignoreQ == "n" {
        pfo = iEqualsJ
    }
    var table [5][5]byte
    pf := &playfair{keyword, pfo, table}
    pf.init()
    pf.printTable()
    fmt.Print("\nEnter plain text : ")
    scanner.Scan()
    plainText := scanner.Text()
    if err := scanner.Err(); err != nil {
        fmt.Fprintln(os.Stderr, "reading standard input:", err)
        return
    }
    encodedText := pf.encode(plainText)
    fmt.Println("\nEncoded text is :", encodedText)
    decodedText := pf.decode(encodedText)
    fmt.Println("Deccoded text is :", decodedText)
}
