package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "strconv"
    "strings"
)

type userInput struct{ formFeed, lineFeed, tab, space int }

func getUserInput() []userInput {
    h := "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " +
        "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"
    flds := strings.Fields(h)
    var uis []userInput
    var uif [4]int
    for i := 0; i < len(flds); i += 4 {
        for j := 0; j < 4; j++ {
            uif[j], _ = strconv.Atoi(flds[i+j])
        }
        uis = append(uis, userInput{uif[0], uif[1], uif[2], uif[3]})
    }
    return uis
}

func decode(fileName string, uis []userInput) error {
    text, err := ioutil.ReadFile(fileName)
    if err != nil {
        return err
    }

    decode2 := func(ui userInput) bool {
        var f, l, t, s int
        for _, c := range text {
            if f == ui.formFeed && l == ui.lineFeed && t == ui.tab && s == ui.space {
                if c == '!' {
                    return false
                }
                fmt.Printf("%c", c)
                return true
            }
            switch c {
            case '\f':
                f++
                l = 0
                t = 0
                s = 0
            case '\n':
                l++
                t = 0
                s = 0
            case '\t':
                t++
                s = 0
            default:
                s++
            }
        }
        return true
    }

    for _, ui := range uis {
        if !decode2(ui) {
            break
        }
    }
    fmt.Println()
    return nil
}

func main() {
    uis := getUserInput()
    err := decode("theRaven.txt", uis)
    if err != nil {
        log.Fatal(err)
    }
}
