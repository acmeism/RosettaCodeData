package main

import (
    "fmt"
    "time"
)

type birthday struct{ month, day int }

func (b birthday) String() string {
    return fmt.Sprintf("%s %d", time.Month(b.month), b.day)
}

func (b birthday) monthUniqueIn(bds []birthday) bool {
    count := 0
    for _, bd := range bds {
        if bd.month == b.month {
            count++
        }
    }
    if count == 1 {
        return true
    }
    return false
}

func (b birthday) dayUniqueIn(bds []birthday) bool {
    count := 0
    for _, bd := range bds {
        if bd.day == b.day {
            count++
        }
    }
    if count == 1 {
        return true
    }
    return false
}

func (b birthday) monthWithUniqueDayIn(bds []birthday) bool {
    for _, bd := range bds {
        if bd.month == b.month && bd.dayUniqueIn(bds) {
            return true
        }
    }
    return false
}

func main() {
    choices := []birthday{
        {5, 15}, {5, 16}, {5, 19}, {6, 17}, {6, 18},
        {7, 14}, {7, 16}, {8, 14}, {8, 15}, {8, 17},
    }

    // Albert knows the month but doesn't know the day.
    // So the month can't be unique within the choices.
    var filtered []birthday
    for _, bd := range choices {
        if !bd.monthUniqueIn(choices) {
            filtered = append(filtered, bd)
        }
    }

    // Albert also knows that Bernard doesn't know the answer.
    // So the month can't have a unique day.
    var filtered2 []birthday
    for _, bd := range filtered {
        if !bd.monthWithUniqueDayIn(filtered) {
            filtered2 = append(filtered2, bd)
        }
    }

    // Bernard now knows the answer.
    // So the day must be unique within the remaining choices.
    var filtered3 []birthday
    for _, bd := range filtered2 {
        if bd.dayUniqueIn(filtered2) {
            filtered3 = append(filtered3, bd)
        }
    }

    // Albert now knows the answer too.
    // So the month must be unique within the remaining choices.
    var filtered4 []birthday
    for _, bd := range filtered3 {
        if bd.monthUniqueIn(filtered3) {
            filtered4 = append(filtered4, bd)
        }
    }

    if len(filtered4) == 1 {
        fmt.Println("Cheryl's birthday is", filtered4[0])
    } else {
        fmt.Println("Something went wrong!")
    }
}
