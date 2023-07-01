package main

import (
    "fmt"
    "strconv"
    "strings"
    "time"
)

var sacred = strings.Fields("Imix’ Ik’ Ak’bal K’an Chikchan Kimi Manik’ Lamat Muluk Ok Chuwen Eb Ben Hix Men K’ib’ Kaban Etz’nab’ Kawak Ajaw")

var civil = strings.Fields("Pop Wo’ Sip Sotz’ Sek Xul Yaxk’in Mol Ch’en Yax Sak’ Keh Mak K’ank’in Muwan’ Pax K’ayab Kumk’u Wayeb’")

var (
    date1 = time.Date(2012, time.December, 21, 0, 0, 0, 0, time.UTC)
    date2 = time.Date(2019, time.April, 2, 0, 0, 0, 0, time.UTC)
)

func tzolkin(date time.Time) (int, string) {
    diff := int(date.Sub(date1).Hours()) / 24
    rem := diff % 13
    if rem < 0 {
        rem = 13 + rem
    }
    var num int
    if rem <= 9 {
        num = rem + 4
    } else {
        num = rem - 9
    }
    rem = diff % 20
    if rem <= 0 {
        rem = 20 + rem
    }
    return num, sacred[rem-1]
}

func haab(date time.Time) (string, string) {
    diff := int(date.Sub(date2).Hours()) / 24
    rem := diff % 365
    if rem < 0 {
        rem = 365 + rem
    }
    month := civil[(rem+1)/20]
    last := 20
    if month == "Wayeb’" {
        last = 5
    }
    d := rem%20 + 1
    if d < last {
        return strconv.Itoa(d), month
    }
    return "Chum", month
}

func longCount(date time.Time) string {
    diff := int(date.Sub(date1).Hours()) / 24
    diff += 13 * 400 * 360
    baktun := diff / (400 * 360)
    diff %= 400 * 360
    katun := diff / (20 * 360)
    diff %= 20 * 360
    tun := diff / 360
    diff %= 360
    winal := diff / 20
    kin := diff % 20
    return fmt.Sprintf("%d.%d.%d.%d.%d", baktun, katun, tun, winal, kin)
}

func lord(date time.Time) string {
    diff := int(date.Sub(date1).Hours()) / 24
    rem := diff % 9
    if rem <= 0 {
        rem = 9 + rem
    }
    return fmt.Sprintf("G%d", rem)
}

func main() {
    const shortForm = "2006-01-02"
    dates := []string{
        "2004-06-19",
        "2012-12-18",
        "2012-12-21",
        "2019-01-19",
        "2019-03-27",
        "2020-02-29",
        "2020-03-01",
        "2071-05-16",
    }
    fmt.Println(" Gregorian   Tzolk’in        Haab’              Long           Lord of")
    fmt.Println("   Date       # Name       Day Month            Count         the Night")
    fmt.Println("----------   --------    -------------        --------------  ---------")
    for _, dt := range dates {
        date, _ := time.Parse(shortForm, dt)
        n, s := tzolkin(date)
        d, m := haab(date)
        lc := longCount(date)
        l := lord(date)
        fmt.Printf("%s   %2d %-8s %4s %-9s       %-14s     %s\n", dt, n, s, d, m, lc, l)
    }
}
