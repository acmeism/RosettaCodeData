package main

import (
    "fmt"
    "sort"
    "strconv"
)

var games = [6]string{"12", "13", "14", "23", "24", "34"}
var results = "000000"

func nextResult() bool {
    if results == "222222" {
        return false
    }
    res, _ := strconv.ParseUint(results, 3, 32)
    results = fmt.Sprintf("%06s", strconv.FormatUint(res+1, 3))
    return true
}

func main() {
    var points [4][10]int
    for {
        var records [4]int
        for i := 0; i < len(games); i++ {
            switch results[i] {
            case '2':
                records[games[i][0]-'1'] += 3
            case '1':
                records[games[i][0]-'1']++
                records[games[i][1]-'1']++
            case '0':
                records[games[i][1]-'1'] += 3
            }
        }
        sort.Ints(records[:])
        for i := 0; i < 4; i++ {
            points[i][records[i]]++
        }
        if !nextResult() {
            break
        }
    }
    fmt.Println("POINTS       0    1    2    3    4    5    6    7    8    9")
    fmt.Println("-------------------------------------------------------------")
    places := [4]string{"1st", "2nd", "3rd", "4th"}
    for i := 0; i < 4; i++ {
        fmt.Print(places[i], " place    ")
        for j := 0; j < 10; j++ {
            fmt.Printf("%-5d", points[3-i][j])
        }
        fmt.Println()
    }
}
