package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

var (
    gregorianStr = []string{"January", "February", "March",
        "April", "May", "June",
        "July", "August", "September",
        "October", "November", "December"}
    gregorian     = []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    republicanStr = []string{"Vendemiaire", "Brumaire", "Frimaire",
        "Nivose", "Pluviose", "Ventose",
        "Germinal", "Floreal", "Prairial",
        "Messidor", "Thermidor", "Fructidor"}
    sansculottidesStr = []string{"Fete de la vertu", "Fete du genie",
        "Fete du travail", "Fete de l'opinion",
        "Fete des recompenses", "Fete de la Revolution"}
)

func main() {
    fmt.Println("*** French  Republican ***")
    fmt.Println("*** calendar converter ***")
    fmt.Println("Enter a date to convert, in the format 'day month year'")
    fmt.Println("e.g.: 1 Prairial 3,")
    fmt.Println("      20 May 1795.")
    fmt.Println("For Sansculottides, use 'day year'")
    fmt.Println("e.g.: Fete de l'opinion 9.")
    fmt.Println("Or just press 'RETURN' to exit the program.")
    fmt.Println()
    for sc := bufio.NewScanner(os.Stdin); ; {
        fmt.Print("> ")
        sc.Scan()
        src := sc.Text()
        if src == "" {
            return
        }
        day, month, year := split(src)
        if year < 1792 {
            day, month, year = dayToGre(repToDay(day, month, year))
            fmt.Println(day, gregorianStr[month-1], year)
        } else {
            day, month, year := dayToRep(greToDay(day, month, year))
            if month == 13 {
                fmt.Println(sansculottidesStr[day-1], year)
            } else {
                fmt.Println(day, republicanStr[month-1], year)
            }
        }
    }
}

func split(s string) (d, m, y int) {
    if strings.HasPrefix(s, "Fete") {
        m = 13
        for i, sc := range sansculottidesStr {
            if strings.HasPrefix(s, sc) {
                d = i + 1
                y, _ = strconv.Atoi(s[len(sc)+1:])
            }
        }
    } else {
        d, _ = strconv.Atoi(s[:strings.Index(s, " ")])
        my := s[strings.Index(s, " ")+1:]
        mStr := my[:strings.Index(my, " ")]
        y, _ = strconv.Atoi(my[strings.Index(my, " ")+1:])
        months := gregorianStr
        if y < 1792 {
            months = republicanStr
        }
        for i, mn := range months {
            if mn == mStr {
                m = i + 1
            }
        }
    }
    return
}

func greToDay(d, m, y int) int {
    if m < 3 {
        y--
        m += 12
    }
    return y*36525/100 - y/100 + y/400 + 306*(m+1)/10 + d - 654842
}

func repToDay(d, m, y int) int {
    if m == 13 {
        m--
        d += 30
    }
    if repLeap(y) {
        d--
    }
    return 365*y + (y+1)/4 - (y+1)/100 + (y+1)/400 + 30*m + d - 395
}

func dayToGre(day int) (d, m, y int) {
    y = day * 100 / 36525
    d = day - y*36525/100 + 21
    y += 1792
    d += y/100 - y/400 - 13
    m = 8
    for d > gregorian[m] {
        d -= gregorian[m]
        m++
        if m == 12 {
            m = 0
            y++
            if greLeap(y) {
                gregorian[1] = 29
            } else {
                gregorian[1] = 28
            }
        }
    }
    m++
    return
}

func dayToRep(day int) (d, m, y int) {
    y = (day-1) * 100 / 36525
    if repLeap(y) {
        y--
    }
    d = day - (y+1)*36525/100 + 365 + (y+1)/100 - (y+1)/400
    y++
    m = 1
    sansculottides := 5
    if repLeap(y) {
        sansculottides = 6
    }
    for d > 30 {
        d -= 30
        m += 1
        if m == 13 {
            if d > sansculottides {
                d -= sansculottides
                m = 1
                y++
                sansculottides = 5
                if repLeap(y) {
                    sansculottides = 6
                }
            }
        }
    }
    return
}

func repLeap(year int) bool {
    return (year+1)%4 == 0 && ((year+1)%100 != 0 || (year+1)%400 == 0)
}

func greLeap(year int) bool {
    return year%4 == 0 && (year%100 != 0 || year%400 == 0)
}
