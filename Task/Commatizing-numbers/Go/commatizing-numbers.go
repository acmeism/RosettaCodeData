package main

import (
    "fmt"
    "regexp"
    "strings"
)

var reg = regexp.MustCompile(`(\.[0-9]+|[1-9]([0-9]+)?(\.[0-9]+)?)`)

func reverse(s string) string {
    r := []rune(s)
    for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
        r[i], r[j] = r[j], r[i]
    }
    return string(r)
}

func commatize(s string, startIndex, period int, sep string) string {
    if startIndex < 0 || startIndex >= len(s) || period < 1 || sep == "" {
        return s
    }
    m := reg.FindString(s[startIndex:]) // this can only contain ASCII characters
    if m == "" {
        return s
    }
    splits := strings.Split(m, ".")
    ip := splits[0]
    if len(ip) > period {
        pi := reverse(ip)
        for i := (len(ip) - 1) / period * period; i >= period; i -= period {
            pi = pi[:i] + sep + pi[i:]
        }
        ip = reverse(pi)
    }
    if strings.Contains(m, ".") {
        dp := splits[1]
        if len(dp) > period {
            for i := (len(dp) - 1) / period * period; i >= period; i -= period {
                dp = dp[:i] + sep + dp[i:]
            }
        }
        ip += "." + dp
    }
    return s[:startIndex] + strings.Replace(s[startIndex:], m, ip, 1)
}

func main() {
    tests := [...]string{
        "123456789.123456789",
        ".123456789",
        "57256.1D-4",
        "pi=3.14159265358979323846264338327950288419716939937510582097494459231",
        "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).",
        "-in Aus$+1411.8millions",
        "===US$0017440 millions=== (in 2000 dollars)",
        "123.e8000 is pretty big.",
        "The land area of the earth is 57268900(29% of the surface) square miles.",
        "Ain't no numbers in this here words, nohow, no way, Jose.",
        "James was never known as 0000000007",
        "Arthur Eddington wrote: I believe there are " +
            "15747724136275002577605653961181555468044717914527116709366231425076185631031296" +
            " protons in the universe.",
        "   $-140000±100 millions.",
        "6/9/1946 was a good year for some.",
    }
    fmt.Println(commatize(tests[0], 0, 2, "*"))
    fmt.Println(commatize(tests[1], 0, 3, "-"))
    fmt.Println(commatize(tests[2], 0, 4, "__"))
    fmt.Println(commatize(tests[3], 0, 5, " "))
    fmt.Println(commatize(tests[4], 0, 3, "."))
    for _, test := range tests[5:] {
        fmt.Println(commatize(test, 0, 3, ","))
    }
}
