package main

import "fmt"

func jaro(str1, str2 string) float64 {
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

func main() {
    fmt.Printf("%f\n", jaro("MARTHA", "MARHTA"))
    fmt.Printf("%f\n", jaro("DIXON", "DICKSONX"))
    fmt.Printf("%f\n", jaro("JELLYFISH", "SMELLYFISH"))
}
