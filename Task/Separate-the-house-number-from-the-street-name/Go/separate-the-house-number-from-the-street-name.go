package main

import (
    "fmt"
    "strings"
)

func isDigit(b byte) bool {
    return '0' <= b && b <= '9'
}

func separateHouseNumber(address string) (street string, house string) {
    length := len(address)
    fields := strings.Fields(address)
    size := len(fields)
    last := fields[size-1]
    penult := fields[size-2]
    if isDigit(last[0]) {
        isdig := isDigit(penult[0])
        if size > 2 && isdig && !strings.HasPrefix(penult, "194") {
            house = fmt.Sprintf("%s %s", penult, last)
        } else {
            house = last
        }
    } else if size > 2 {
        house = fmt.Sprintf("%s %s", penult, last)
    }
    street = strings.TrimRight(address[:length-len(house)], " ")
    return
}

func main() {
    addresses := [...]string{
        "Plataanstraat 5",
        "Straat 12",
        "Straat 12 II",
        "Dr. J. Straat   12",
        "Dr. J. Straat 12 a",
        "Dr. J. Straat 12-14",
        "Laan 1940 - 1945 37",
        "Plein 1940 2",
        "1213-laan 11",
        "16 april 1944 Pad 1",
        "1e Kruisweg 36",
        "Laan 1940-'45 66",
        "Laan '40-'45",
        "Langeloërduinen 3 46",
        "Marienwaerdt 2e Dreef 2",
        "Provincialeweg N205 1",
        "Rivium 2e Straat 59.",
        "Nieuwe gracht 20rd",
        "Nieuwe gracht 20rd 2",
        "Nieuwe gracht 20zw /2",
        "Nieuwe gracht 20zw/3",
        "Nieuwe gracht 20 zw/4",
        "Bahnhofstr. 4",
        "Wertstr. 10",
        "Lindenhof 1",
        "Nordesch 20",
        "Weilstr. 6",
        "Harthauer Weg 2",
        "Mainaustr. 49",
        "August-Horch-Str. 3",
        "Marktplatz 31",
        "Schmidener Weg 3",
        "Karl-Weysser-Str. 6",
    }
    fmt.Println("Street                   House Number")
    fmt.Println("---------------------    ------------")
    for _, address := range addresses {
        street, house := separateHouseNumber(address)
        if house == "" {
            house = "(none)"
        }
        fmt.Printf("%-22s   %s\n", street, house)
    }
}
