package main

import (
    "fmt"
    "log"
    "time"
)

const layout = "2006-01-02" // template for time.Parse

// Parameters assumed to be in YYYY-MM-DD format.
func daysBetween(date1, date2 string) int {
    t1, err := time.Parse(layout, date1)
    check(err)
    t2, err := time.Parse(layout, date2)
    check(err)
    days := int(t1.Sub(t2).Hours() / 24)
    if days < 0 {
        days = -days
    }
    return days
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    date1, date2 := "2019-01-01", "2019-09-30"
    days := daysBetween(date1, date2)
    fmt.Printf("There are %d days between %s and %s\n", days, date1, date2)

    date1, date2 = "2015-12-31", "2016-09-30"
    days = daysBetween(date1, date2)
    fmt.Printf("There are %d days between %s and %s\n", days, date1, date2)
}
