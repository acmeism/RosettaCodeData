package main

import (
    "fmt"
    "math/rand"
    "strings"
    "time"
)

func main() {
    rand.Seed(time.Now().UnixNano())
    for i := 99; i > 0; i-- {
        fmt.Printf("%s %s %s\n",
            slur(numberName(i), i),
            pluralizeFirst(slur("bottle of", i), i),
            slur("beer on the wall", i))
        fmt.Printf("%s %s %s\n",
            slur(numberName(i), i),
            pluralizeFirst(slur("bottle of", i), i),
            slur("beer", i))
        fmt.Printf("%s %s %s\n",
            slur("take one", i),
            slur("down", i),
            slur("pass it around", i))
        fmt.Printf("%s %s %s\n",
            slur(numberName(i-1), i),
            pluralizeFirst(slur("bottle of", i), i-1),
            slur("beer on the wall", i))
    }
}

// adapted from Number names task
func numberName(n int) string {
    switch {
    case n < 0:
    case n < 20:
        return small[n]
    case n < 100:
        t := tens[n/10]
        s := n % 10
        if s > 0 {
            t += " " + small[s]
        }
        return t
    }
    return ""
}

var small = []string{"no", "one", "two", "three", "four", "five", "six",
    "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen",
    "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
var tens = []string{"ones", "ten", "twenty", "thirty", "forty",
    "fifty", "sixty", "seventy", "eighty", "ninety"}

// pluralize first word of s by adding an s, but only if n is not 1.
func pluralizeFirst(s string, n int) string {
    if n == 1 {
        return s
    }
    w := strings.Fields(s)
    w[0] += "s"
    return strings.Join(w, " ")
}

// p is string to slur, d is drunkenness, from 0 to 99
func slur(p string, d int) string {
    // shuffle only interior letters
    a := []byte(p[1 : len(p)-1])
    // adapted from Knuth shuffle task.
    // shuffle letters with probability d/100.
    for i := len(a) - 1; i >= 1; i-- {
        if rand.Intn(100) >= d {
            j := rand.Intn(i + 1)
            a[i], a[j] = a[j], a[i]
        }
    }
    // condense spaces
    w := strings.Fields(p[:1] + string(a) + p[len(p)-1:])
    return strings.Join(w, " ")
}
