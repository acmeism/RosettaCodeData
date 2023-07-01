package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "math/rand"
    "sort"
    "strings"
    "time"
)

var adfgvx = "ADFGVX"
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func distinct(bs []byte) []byte {
    var u []byte
    for _, b := range bs {
        if !bytes.Contains(u, []byte{b}) {
            u = append(u, b)
        }
    }
    return u
}

func allAsciiAlphaNum(word []byte) bool {
    for _, b := range word {
        if !((b >= 48 && b <= 57) || (b >= 65 && b <= 90) || (b >= 97 && b <= 122)) {
            return false
        }
    }
    return true
}

func orderKey(key string) []int {
    temp := make([][2]byte, len(key))
    for i := 0; i < len(key); i++ {
        temp[i] = [2]byte{key[i], byte(i)}
    }
    sort.Slice(temp, func(i, j int) bool { return temp[i][0] < temp[j][0] })
    res := make([]int, len(key))
    for i := 0; i < len(key); i++ {
        res[i] = int(temp[i][1])
    }
    return res
}

func createPolybius() []string {
    temp := []byte(alphabet)
    rand.Shuffle(36, func(i, j int) {
        temp[i], temp[j] = temp[j], temp[i]
    })
    alphabet = string(temp)
    fmt.Println("6 x 6 Polybius square:\n")
    fmt.Println("  | A D F G V X")
    fmt.Println("---------------")
    p := make([]string, 6)
    for i := 0; i < 6; i++ {
        fmt.Printf("%c | ", adfgvx[i])
        p[i] = alphabet[6*i : 6*(i+1)]
        for _, c := range p[i] {
            fmt.Printf("%c ", c)
        }
        fmt.Println()
    }
    return p
}

func createKey(n int) string {
    if n < 7 || n > 12 {
        log.Fatal("Key should be within 7 and 12 letters long.")
    }
    bs, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        log.Fatal("Error reading file")
    }
    words := bytes.Split(bs, []byte{'\n'})
    var candidates [][]byte
    for _, word := range words {
        if len(word) == n && len(distinct(word)) == n && allAsciiAlphaNum(word) {
            candidates = append(candidates, word)
        }
    }
    k := string(bytes.ToUpper(candidates[rand.Intn(len(candidates))]))
    fmt.Println("\nThe key is", k)
    return k
}

func encrypt(polybius []string, key, plainText string) string {
    temp := ""
outer:
    for _, ch := range []byte(plainText) {
        for r := 0; r <= 5; r++ {
            for c := 0; c <= 5; c++ {
                if polybius[r][c] == ch {
                    temp += fmt.Sprintf("%c%c", adfgvx[r], adfgvx[c])
                    continue outer
                }
            }
        }
    }
    colLen := len(temp) / len(key)
    // all columns need to be the same length
    if len(temp)%len(key) > 0 {
        colLen++
    }
    table := make([][]string, colLen)
    for i := 0; i < colLen; i++ {
        table[i] = make([]string, len(key))
    }
    for i := 0; i < len(temp); i++ {
        table[i/len(key)][i%len(key)] = string(temp[i])
    }
    order := orderKey(key)
    cols := make([][]string, len(key))
    for i := 0; i < len(key); i++ {
        cols[i] = make([]string, colLen)
        for j := 0; j < colLen; j++ {
            cols[i][j] = table[j][order[i]]
        }
    }
    res := make([]string, len(cols))
    for i := 0; i < len(cols); i++ {
        res[i] = strings.Join(cols[i], "")
    }
    return strings.Join(res, " ")
}

func decrypt(polybius []string, key, cipherText string) string {
    colStrs := strings.Split(cipherText, " ")
    // ensure all columns are same length
    maxColLen := 0
    for _, s := range colStrs {
        if len(s) > maxColLen {
            maxColLen = len(s)
        }
    }
    cols := make([][]string, len(colStrs))
    for i, s := range colStrs {
        var ls []string
        for _, c := range s {
            ls = append(ls, string(c))
        }
        if len(s) < maxColLen {
            cols[i] = make([]string, maxColLen)
            copy(cols[i], ls)
        } else {
            cols[i] = ls
        }
    }
    table := make([][]string, maxColLen)
    order := orderKey(key)
    for i := 0; i < maxColLen; i++ {
        table[i] = make([]string, len(key))
        for j := 0; j < len(key); j++ {
            table[i][order[j]] = cols[j][i]
        }
    }
    temp := ""
    for i := 0; i < len(table); i++ {
        temp += strings.Join(table[i], "")
    }
    plainText := ""
    for i := 0; i < len(temp); i += 2 {
        r := strings.IndexByte(adfgvx, temp[i])
        c := strings.IndexByte(adfgvx, temp[i+1])
        plainText = plainText + string(polybius[r][c])
    }
    return plainText
}

func main() {
    rand.Seed(time.Now().UnixNano())
    plainText := "ATTACKAT1200AM"
    polybius := createPolybius()
    key := createKey(9)
    fmt.Println("\nPlaintext :", plainText)
    cipherText := encrypt(polybius, key, plainText)
    fmt.Println("\nEncrypted :", cipherText)
    plainText2 := decrypt(polybius, key, cipherText)
    fmt.Println("\nDecrypted :", plainText2)
}
