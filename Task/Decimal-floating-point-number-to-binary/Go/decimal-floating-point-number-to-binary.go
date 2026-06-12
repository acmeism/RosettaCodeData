package main

import (
    "fmt"
    "math"
    "strconv"
    "strings"
)

func decToBin(d float64) string {
    whole := int64(math.Floor(d))
    binary := strconv.FormatInt(whole, 2) + "."
    dd := d - float64(whole)
    for dd > 0.0 {
        r := dd * 2.0
        if r >= 1.0 {
            binary += "1"
            dd = r - 1.0
        } else {
            binary += "0"
            dd = r
        }
    }
    return binary
}

func binToDec(s string) float64 {
    ss := strings.Replace(s, ".", "", 1)
    num, _ := strconv.ParseInt(ss, 2, 64)
    ss = strings.Split(s, ".")[1]
    ss = strings.Replace(ss, "1", "0", -1)
    den, _ := strconv.ParseInt("1" + ss, 2, 64)
    return float64(num) / float64(den)
}

func main() {
    f := 23.34375
    fmt.Printf("%v\t => %s\n", f, decToBin(f))
    s := "1011.11101"
    fmt.Printf("%s\t => %v\n", s, binToDec(s))
}
