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
    var (
        badRun, maxRun   int
        badDate, maxDate string
        fileSum          float64
        fileAccept       int
    )
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
        var accept int
        var sum float64
        for i := 1; i < 49; i += 2 {
            flag, err := strconv.Atoi(f[i+1])
            if err != nil {
                fmt.Println(err)
                return
            }
            if flag > 0 { // value is good
                if badRun > 0 { // terminate bad run
                    if badRun > maxRun {
                        maxRun = badRun
                        maxDate = badDate
                    }
                    badRun = 0
                }
                value, err := strconv.ParseFloat(f[i], 64)
                if err != nil {
                    fmt.Println(err)
                    return
                }
                sum += value
                accept++
            } else { // value is bad
                if badRun == 0 {
                    badDate = f[0]
                }
                badRun++
            }
        }
        fmt.Printf("Line: %s  Reject %2d  Accept: %2d  Line_tot:%9.3f",
            f[0], 24-accept, accept, sum)
        if accept > 0 {
            fmt.Printf("  Line_avg:%8.3f\n", sum/float64(accept))
        } else {
            fmt.Println("")
        }
        fileSum += sum
        fileAccept += accept
    }
    fmt.Println("\nFile     =", fn)
    fmt.Printf("Total    = %.3f\n", fileSum)
    fmt.Println("Readings = ", fileAccept)
    if fileAccept > 0 {
        fmt.Printf("Average  =  %.3f\n", fileSum/float64(fileAccept))
    }
    if badRun > 0 && badRun > maxRun {
        maxRun = badRun
        maxDate = badDate
    }
    if maxRun == 0 {
        fmt.Println("\nAll data valid.")
    } else {
        fmt.Printf("\nMax data gap = %d, beginning on line %s.\n",
            maxRun, maxDate)
    }
}
