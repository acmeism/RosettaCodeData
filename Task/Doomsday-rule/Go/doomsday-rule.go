package main

import (
    "fmt"
    "strconv"
)

var days = []string{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

func anchorDay(y int) int {
    return (2 + 5*(y%4) + 4*(y%100) + 6*(y%400)) % 7
}

func isLeapYear(y int) bool { return y%4 == 0 && (y%100 != 0 || y%400 == 0) }

var firstDaysCommon = []int{3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5}
var firstDaysLeap = []int{4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5}

func main() {
    dates := []string{
        "1800-01-06",
        "1875-03-29",
        "1915-12-07",
        "1970-12-23",
        "2043-05-14",
        "2077-02-12",
        "2101-04-02",
    }

    fmt.Println("Days of week given by Doomsday rule:")
    for _, date := range dates {
        y, _ := strconv.Atoi(date[0:4])
        m, _ := strconv.Atoi(date[5:7])
        m--
        d, _ := strconv.Atoi(date[8:10])
        a := anchorDay(y)
        f := firstDaysCommon[m]
        if isLeapYear(y) {
            f = firstDaysLeap[m]
        }
        w := d - f
        if w < 0 {
            w = 7 + w
        }
        dow := (a + w) % 7
        fmt.Printf("%s -> %s\n", date, days[dow])
    }
}
