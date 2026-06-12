package main

import (
    "fmt"
    "strconv"
    "strings"
    "unicode/utf8"
)

func sign(n int) int {
    switch {
    case n < 0:
        return -1
    case n > 0:
        return 1
    }
    return 0
}

func abs(n int) int {
    if n < 0 {
        return -n
    }
    return n
}

func parseRange(r string) []string {
    if r == "" {
        return []string{"{}"} // rangeless, empty
    }
    sp := strings.Split(r, "..")
    if len(sp) == 1 {
        return []string{"{" + r + "}"} // rangeless, random value
    }
    sta := sp[0]
    end := sp[1]
    inc := "1"
    if len(sp) > 2 {
        inc = sp[2]
    }
    n1, ok1 := strconv.Atoi(sta)
    n2, ok2 := strconv.Atoi(end)
    n3, ok3 := strconv.Atoi(inc)
    if ok3 != nil {
        return []string{"{" + r + "}"} // increment isn't a number
    }
    numeric := (ok1 == nil) && (ok2 == nil)
    if !numeric {
        if (ok1 == nil && ok2 != nil) || (ok1 != nil && ok2 == nil) {
            return []string{"{" + r + "}"} // mixed numeric/alpha not expanded
        }
        if utf8.RuneCountInString(sta) != 1 || utf8.RuneCountInString(end) != 1 {
            return []string{"{" + r + "}"} // start/end are not both single alpha
        }
        n1 = int(([]rune(sta))[0])
        n2 = int(([]rune(end))[0])
    }
    width := 1
    if numeric {
        if len(sta) < len(end) {
            width = len(end)
        } else {
            width = len(sta)
        }
    }
    if n3 == 0 { // zero increment
        if numeric {
            return []string{fmt.Sprintf("%0*d", width, n1)}
        } else {
            return []string{sta}
        }
    }
    var res []string
    asc := n1 < n2
    if n3 < 0 {
        asc = !asc
        t := n1
        d := abs(n1-n2) % (-n3)
        n1 = n2 - d*sign(n2-n1)
        n2 = t
        n3 = -n3
    }
    i := n1
    if asc {
        for ; i <= n2; i += n3 {
            if numeric {
                res = append(res, fmt.Sprintf("%0*d", width, i))
            } else {
                res = append(res, string(rune(i)))
            }
        }
    } else {
        for ; i >= n2; i -= n3 {
            if numeric {
                res = append(res, fmt.Sprintf("%0*d", width, i))
            } else {
                res = append(res, string(rune(i)))
            }
        }
    }
    return res
}

func rangeExpand(s string) []string {
    res := []string{""}
    rng := ""
    inRng := false
    for _, c := range s {
        if c == '{' && !inRng {
            inRng = true
            rng = ""
        } else if c == '}' && inRng {
            rngRes := parseRange(rng)
            rngLen := len(rngRes)
            var res2 []string
            for i := 0; i < len(res); i++ {
                for j := 0; j < rngLen; j++ {
                    res2 = append(res2, res[i]+rngRes[j])
                }
            }
            res = res2
            inRng = false
        } else if inRng {
            rng += string(c)
        } else {
            for i := 0; i < len(res); i++ {
                res[i] += string(c)
            }
        }
    }
    if inRng {
        for i := 0; i < len(res); i++ {
            res[i] += "{" + rng // unmatched braces
        }
    }
    return res
}

func main() {
    examples := []string{
        "simpleNumberRising{1..3}.txt",
        "simpleAlphaDescending-{Z..X}.txt",
        "steppedDownAndPadded-{10..00..5}.txt",
        "minusSignFlipsSequence {030..20..-5}.txt",
        "reverseSteppedNumberRising{1..6..-2}.txt",
        "combined-{Q..P}{2..1}.txt",
        "emoji{🌵..🌶}{🌽..🌾}etc",
        "li{teral",
        "rangeless{}empty",
        "rangeless{random}string",
        "mixedNumberAlpha{5..k}",
        "steppedAlphaRising{P..Z..2}.txt",
        "stops after endpoint-{02..10..3}.txt",
        "steppedNumberRising{1..6..2}.txt",
        "steppedNumberDescending{20..9..2}",
        "steppedAlphaDescending-{Z..M..2}.txt",
        "reversedSteppedAlphaDescending-{Z..M..-2}.txt",
    }
    for _, s := range examples {
        fmt.Print(s, "->\n    ")
        res := rangeExpand(s)
        fmt.Println(strings.Join(res, "\n    "))
        fmt.Println()
    }
}
