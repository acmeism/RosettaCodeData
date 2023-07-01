package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "sort"
    "strings"
)

func main() {
    b, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        log.Fatal("Error reading file")
    }
    letters := "deegklnow"
    wordsAll := bytes.Split(b, []byte{'\n'})
    // get rid of words under 3 letters or over 9 letters
    var words [][]byte
    for _, word := range wordsAll {
        word = bytes.TrimSpace(word)
        le := len(word)
        if le > 2 && le < 10 {
            words = append(words, word)
        }
    }
    var found []string
    for _, word := range words {
        le := len(word)
        if bytes.IndexByte(word, 'k') >= 0 {
            lets := letters
            ok := true
            for i := 0; i < le; i++ {
                c := word[i]
                ix := sort.Search(len(lets), func(i int) bool { return lets[i] >= c })
                if ix < len(lets) && lets[ix] == c {
                    lets = lets[0:ix] + lets[ix+1:]
                } else {
                    ok = false
                    break
                }
            }
            if ok {
                found = append(found, string(word))
            }
        }
    }
    fmt.Println("The following", len(found), "words are the solutions to the puzzle:")
    fmt.Println(strings.Join(found, "\n"))

    // optional extra
    mostFound := 0
    var mostWords9 []string
    var mostLetters []byte
    // extract 9 letter words
    var words9 [][]byte
    for _, word := range words {
        if len(word) == 9 {
            words9 = append(words9, word)
        }
    }
    // iterate through them
    for _, word9 := range words9 {
        letterBytes := make([]byte, len(word9))
        copy(letterBytes, word9)
        sort.Slice(letterBytes, func(i, j int) bool { return letterBytes[i] < letterBytes[j] })
        // get distinct bytes
        distinctBytes := []byte{letterBytes[0]}
        for _, b := range letterBytes[1:] {
            if b != distinctBytes[len(distinctBytes)-1] {
                distinctBytes = append(distinctBytes, b)
            }
        }
        distinctLetters := string(distinctBytes)
        for _, letter := range distinctLetters {
            found := 0
            letterByte := byte(letter)
            for _, word := range words {
                le := len(word)
                if bytes.IndexByte(word, letterByte) >= 0 {
                    lets := string(letterBytes)
                    ok := true
                    for i := 0; i < le; i++ {
                        c := word[i]
                        ix := sort.Search(len(lets), func(i int) bool { return lets[i] >= c })
                        if ix < len(lets) && lets[ix] == c {
                            lets = lets[0:ix] + lets[ix+1:]
                        } else {
                            ok = false
                            break
                        }
                    }
                    if ok {
                        found = found + 1
                    }
                }
            }
            if found > mostFound {
                mostFound = found
                mostWords9 = []string{string(word9)}
                mostLetters = []byte{letterByte}
            } else if found == mostFound {
                mostWords9 = append(mostWords9, string(word9))
                mostLetters = append(mostLetters, letterByte)
            }
        }
    }
    fmt.Println("\nMost words found =", mostFound)
    fmt.Println("Nine letter words producing this total:")
    for i := 0; i < len(mostWords9); i++ {
        fmt.Println(mostWords9[i], "with central letter", string(mostLetters[i]))
    }
}
