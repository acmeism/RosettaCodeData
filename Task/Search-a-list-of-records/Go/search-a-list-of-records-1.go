package main

import (
    "fmt"
    "strings"
)

type element struct {
    name       string
    population float64
}

var list = []element{
    {"Lagos", 21},
    {"Cairo", 15.2},
    {"Kinshasa-Brazzaville", 11.3},
    {"Greater Johannesburg", 7.55},
    {"Mogadishu", 5.85},
    {"Khartoum-Omdurman", 4.98},
    {"Dar Es Salaam", 4.7},
    {"Alexandria", 4.58},
    {"Abidjan", 4.4},
    {"Casablanca", 3.98},
}

func find(cond func(*element) bool) int {
    for i := range list {
        if cond(&list[i]) {
            return i
        }
    }
    return -1
}

func main() {
    fmt.Println(find(func(e *element) bool {
        return e.name == "Dar Es Salaam"
    }))

    i := find(func(e *element) bool {
        return e.population < 5
    })
    if i < 0 {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(list[i].name)
    }

    i = find(func(e *element) bool {
        return strings.HasPrefix(e.name, "A")
    })
    if i < 0 {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(list[i].population)
    }
}
