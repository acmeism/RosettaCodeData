package frc

import (
    "fmt"
    "strconv"
    "strings"
    "time"
)

type Date struct {
    Year  int
    Month int
    Day   int
}

func (d Date) String() string {
    if d.Month == 13 {
        return fmt.Sprintf("%s %d", sansculotidesStr[d.Day-1], d.Year)
    }
    return fmt.Sprintf("%d %s %d", d.Day, republicanStr[d.Month-1], d.Year)
}

func Parse(s string) (dt Date, ok bool) {
    f := strings.Fields(s)
    var err error
    switch {
    case len(f) == 3:
        if dt.Day, err = strconv.Atoi(f[0]); err != nil {
            return
        }
        i := 0
        for republicanStr[i] != f[1] {
            i++
            if i == len(republicanStr) {
                return
            }
        }
        dt.Month = i + 1
        if dt.Year, err = strconv.Atoi(f[2]); err != nil {
            return
        }
        ok = true
        return
    case len(f) > 3:
        for i, sc := range sansculotidesStr {
            if strings.HasPrefix(s, sc) {
                dt.Month = 13
                dt.Day = i + 1
                dt.Year, err = strconv.Atoi(s[len(sc)+1:])
                if err == nil {
                    ok = true
                }
                return
            }
        }
    }
    return
}

func (dt Date) ToGregorian() (y int, m time.Month, d int) {
    yr, mn, dy := dayToGre(repToDay(dt.Day, dt.Month, dt.Year))
    return yr, time.Month(mn), dy
}

func FromGregorian(y int, m time.Month, d int) Date {
    day, month, year := dayToRep(greToDay(d, int(m), y))
    return Date{Year: year, Month: month, Day: day}
}
var (
    gregorian     = []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    republicanStr = []string{"Vendemiaire", "Brumaire", "Frimaire",
        "Nivose", "Pluviose", "Ventose",
        "Germinal", "Floreal", "Prairial",
        "Messidor", "Thermidor", "Fructidor"}
    sansculotidesStr = []string{"Fete de la vertu", "Fete du genie",
        "Fete du travail", "Fete de l'opinion",
        "Fete des recompenses", "Fete de la Revolution"}
)

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
