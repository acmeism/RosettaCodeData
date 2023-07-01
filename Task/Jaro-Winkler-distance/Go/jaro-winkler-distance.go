package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "sort"
)

func jaroSim(str1, str2 string) float64 {
    if len(str1) == 0 && len(str2) == 0 {
        return 1
    }
    if len(str1) == 0 || len(str2) == 0 {
        return 0
    }
    match_distance := len(str1)
    if len(str2) > match_distance {
        match_distance = len(str2)
    }
    match_distance = match_distance/2 - 1
    str1_matches := make([]bool, len(str1))
    str2_matches := make([]bool, len(str2))
    matches := 0.
    transpositions := 0.
    for i := range str1 {
        start := i - match_distance
        if start < 0 {
            start = 0
        }
        end := i + match_distance + 1
        if end > len(str2) {
            end = len(str2)
        }
        for k := start; k < end; k++ {
            if str2_matches[k] {
                continue
            }
            if str1[i] != str2[k] {
                continue
            }
            str1_matches[i] = true
            str2_matches[k] = true
            matches++
            break
        }
    }
    if matches == 0 {
        return 0
    }
    k := 0
    for i := range str1 {
        if !str1_matches[i] {
            continue
        }
        for !str2_matches[k] {
            k++
        }
        if str1[i] != str2[k] {
            transpositions++
        }
        k++
    }
    transpositions /= 2
    return (matches/float64(len(str1)) +
        matches/float64(len(str2)) +
        (matches-transpositions)/matches) / 3
}

func jaroWinklerDist(s, t string) float64 {
    ls := len(s)
    lt := len(t)
    lmax := lt
    if ls < lt {
        lmax = ls
    }
    if lmax > 4 {
        lmax = 4
    }
    l := 0
    for i := 0; i < lmax; i++ {
        if s[i] == t[i] {
            l++
        }
    }
    js := jaroSim(s, t)
    p := 0.1
    ws := js + float64(l)*p*(1-js)
    return 1 - ws
}

type wd struct {
    word string
    dist float64
}

func main() {
    misspelt := []string{
        "accomodate", "definately", "goverment", "occured", "publically",
        "recieve", "seperate", "untill", "wich",
    }
    b, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        log.Fatal("Error reading file")
    }
    words := bytes.Fields(b)
    for _, ms := range misspelt {
        var closest []wd
        for _, w := range words {
            word := string(w)
            if word == "" {
                continue
            }
            jwd := jaroWinklerDist(ms, word)
            if jwd < 0.15 {
                closest = append(closest, wd{word, jwd})
            }
        }
        fmt.Println("Misspelt word:", ms, ":")
        sort.Slice(closest, func(i, j int) bool { return closest[i].dist < closest[j].dist })
        for i, c := range closest {
            fmt.Printf("%0.4f %s\n", c.dist, c.word)
            if i == 5 {
                break
            }
        }
        fmt.Println()
    }
}
