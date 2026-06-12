package main

import (
    "fmt"
    "go/parser"
    "regexp"
    "strings"
)

var (
    re1 = regexp.MustCompile(`[^_a-zA-Z0-9\+\-\*/=<\(\)\s]`)
    re2 = regexp.MustCompile(`\b_\w*\b`)
    re3 = regexp.MustCompile(`[=<+*/-]\s*not`)
    re4 = regexp.MustCompile(`(=|<)\s*[^(=< ]+\s*([=<+*/-])`)
)

var subs = [][2]string{
    {"=", "=="}, {" not ", " ! "}, {"(not ", "(! "}, {" or ", " || "}, {" and ", " && "},
}

func possiblyValid(expr string) error {
    matches := re1.FindStringSubmatch(expr)
    if matches != nil {
        return fmt.Errorf("invalid character %q found", []rune(matches[0])[0])
    }
    if re2.MatchString(expr) {
        return fmt.Errorf("identifier cannot begin with an underscore")
    }
    if re3.MatchString(expr) {
        return fmt.Errorf("expected operand, found 'not'")
    }
    matches = re4.FindStringSubmatch(expr)
    if matches != nil {
        return fmt.Errorf("operator %q is non-associative", []rune(matches[1])[0])
    }
    return nil
}

func modify(err error) string {
    e := err.Error()
    for _, sub := range subs {
        e = strings.ReplaceAll(e, strings.TrimSpace(sub[1]), strings.TrimSpace(sub[0]))
    }
    return strings.Split(e, ":")[2][1:] // remove location info as may be inaccurate
}

func main() {
    exprs := []string{
        "$",
        "one",
        "either or both",
        "a + 1",
        "a + b < c",
        "a = b",
        "a or b = c",
        "3 + not 5",
        "3 + (not 5)",
        "(42 + 3",
        "(42 + 3)",
        " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
        " and 3 < 2",
        "not 7 < 2",
        "2 < 3 < 4",
        "2 < (3 < 4)",
        "2 < foobar - 3 < 4",
        "2 < foobar and 3 < 4",
        "4 * (32 - 16) + 9 = 73",
        "235 76 + 1",
        "true or false = not true",
        "true or false = (not true)",
        "not true or false = false",
        "not true = false",
        "a + b = not c and false",
        "a + b = (not c) and false",
        "a + b = (not c and false)",
        "ab_c / bd2 or < e_f7",
        "g not = h",
        "été = false",
        "i++",
        "j & k",
        "l or _m",
    }

    for _, expr := range exprs {
        fmt.Printf("Statement to verify: %q\n", expr)
        if err := possiblyValid(expr); err != nil {
            fmt.Printf("\"false\" -> %s\n\n", err.Error())
            continue
        }
        expr = fmt.Sprintf(" %s ", expr) // make sure there are spaces at both ends
        for _, sub := range subs {
            expr = strings.ReplaceAll(expr, sub[0], sub[1])
        }
        _, err := parser.ParseExpr(expr)
        if err != nil {
            fmt.Println(`"false" ->`, modify(err))
        } else {
            fmt.Println(`"true"`)
        }
        fmt.Println()
    }
}
