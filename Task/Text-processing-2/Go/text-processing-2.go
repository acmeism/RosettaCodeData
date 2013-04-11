package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
    "strconv"
    "strings"
)

var fn = "readings.txt"

func main() {
    f, err := os.Open(fn)
    if err != nil {
        fmt.Println(err)
        return
    }
    defer f.Close()
    var allGood, uniqueGood int
    // map records not only dates seen, but also if an all-good record was
    // seen for the key date.
    m := make(map[string]bool)
    for lr := bufio.NewReader(f); ; {
        line, pref, err := lr.ReadLine()
        if err == io.EOF {
            break
        }
        if err != nil {
            fmt.Println(err)
            return
        }
        if pref {
            fmt.Println("Unexpected long line.")
            return
        }
        f := strings.Fields(string(line))
        if len(f) != 49 {
            fmt.Println("unexpected format,", len(f), "fields.")
            return
        }
        good := true
        for i := 1; i < 49; i += 2 {
            flag, err := strconv.Atoi(f[i+1])
            if err != nil {
                fmt.Println(err)
                return
            }
            if flag > 0 { // value is good
                _, err := strconv.ParseFloat(f[i], 64)
                if err != nil {
                    fmt.Println(err)
                    return
                }
            } else { // value is bad
                good = false
            }
        }
        if good {
            allGood++
        }
        previouslyGood, seen := m[f[0]]
        if seen {
            fmt.Println("Duplicate datestamp:", f[0])
            if !previouslyGood && good {
                m[string([]byte(f[0]))] = true
                uniqueGood++
            }
        } else {
            m[string([]byte(f[0]))] = good
            if good {
                uniqueGood++
            }
        }
    }
    fmt.Println("\nData format valid.")
    fmt.Println(allGood, "records with good readings for all instruments.")
    fmt.Println(uniqueGood,
        "unique dates with good readings for all instruments.")
}
