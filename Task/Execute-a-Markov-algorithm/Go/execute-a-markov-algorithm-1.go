package main

import (
    "fmt"
    "strings"
)

type testCase struct {
    ruleSet, sample, output string
}

var testSet []testCase // initialized in separate source file

func main() {
    fmt.Println("validating", len(testSet), "test cases")
    var failures bool
    for i, tc := range testSet {
        if r := ma(tc.ruleSet, tc.sample); r != tc.output {
            fmt.Println("test", i+1, "fail")
            failures = true
        }
    }
    if !failures {
        fmt.Println("no failures")
    }
}

type rule struct {
    pat  string
    rep  string
    term bool
}

func ma(rs, s string) string {
    // compile rules per task description
    var rules []rule
    for _, line := range strings.Split(rs, "\n") {
        if line == "" || line[0] == '#' {
            continue
        }
        a := strings.Index(line, "->")
        if a == -1 {
            fmt.Println("invalid rule:", line)
            return ""

        }
        pat := line[:a]
        for {
            if pat == "" {
                b := strings.Index(line[a+2:], "->")
                if b == -1 {
                    fmt.Println("invalid rule:", line)
                    return ""
                }
                a += 2 + b
                pat = line[:a]
                continue
            }
            last := pat[len(pat)-1]
            if last != ' ' && last != '\t' {
                break
            }
            pat = pat[:len(pat)-1]
        }
        rep := line[a+2:]
        for rep > "" && (rep[0] == ' ' || rep[0] == '\t') {
            rep = rep[1:]
        }
        var term bool
        if rep > "" && rep[0] == '.' {
            term = true
            rep = rep[1:]
        }
        rules = append(rules, rule{pat, rep, term})
    }
    // execute algorithm per WP
    for r := 0; r < len(rules); {
        pat := rules[r].pat
        if f := strings.Index(s, pat); f == -1 {
            r++
        } else {

            s = s[:f] + rules[r].rep + s[f+len(pat):]
            if rules[r].term {
                break
            }
            r = 0
        }
    }
    return s
}
