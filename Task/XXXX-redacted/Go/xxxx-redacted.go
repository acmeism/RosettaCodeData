package main

import (
    "fmt"
    "github.com/rivo/uniseg"
    "log"
    "regexp"
    "strings"
)

func join(words, seps []string) string {
    lw := len(words)
    ls := len(seps)
    if lw != ls+1 {
        log.Fatal("mismatch between number of words and separators")
    }
    var sb strings.Builder
    for i := 0; i < ls; i++ {
        sb.WriteString(words[i])
        sb.WriteString(seps[i])
    }
    sb.WriteString(words[lw-1])
    return sb.String()
}

func redact(text, word, opts string) {
    var partial, overkill bool
    exp := word
    if strings.IndexByte(opts, 'p') >= 0 {
        partial = true
    }
    if strings.IndexByte(opts, 'o') >= 0 {
        overkill = true
    }
    if strings.IndexByte(opts, 'i') >= 0 {
        exp = `(?i)` + exp
    }
    rgx := regexp.MustCompile(`[\s!-&(-,./:-@[-^{-~]+`) // all punctuation except -'_
    seps := rgx.FindAllString(text, -1)
    words := rgx.Split(text, -1)
    rgx2 := regexp.MustCompile(exp)
    for i, w := range words {
        match := rgx2.FindString(w)
        // check there's a match and it's not part of a ZWJ emoji
        if match == "" || strings.Index(w, match+"\u200d") >= 0 ||
            strings.Index(w, "\u200d"+match) >= 0 {
            continue
        }
        switch {
        case overkill:
            words[i] = strings.Repeat("X", uniseg.GraphemeClusterCount(w))
        case !partial:
            if words[i] == match {
                words[i] = strings.Repeat("X", uniseg.GraphemeClusterCount(w))
            }
        case partial:
            repl := strings.Repeat("X", uniseg.GraphemeClusterCount(word))
            words[i] = rgx2.ReplaceAllLiteralString(w, repl)
        }
    }
    fmt.Printf("%s %s\n\n", opts, join(words, seps))
}

func printResults(text string, allOpts, allWords []string) {
    fmt.Printf("Text: %s\n\n", text)
    for _, word := range allWords {
        fmt.Printf("Redact '%s':\n", word)
        for _, opts := range allOpts {
            redact(text, word, opts)
        }
    }
    fmt.Println()
}

func main() {
    text := `Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
'Tis very tomish, don't you think?`
    allOpts := []string{"[w|s|n]", "[w|i|n]", "[p|s|n]", "[p|i|n]", "[p|s|o]", "[p|i|o]"}
    allWords := []string{"Tom", "tom", "t"}
    printResults(text, allOpts, allWords)

    text = "🧑 👨 🧔 👨‍👩‍👦"
    allOpts = []string{"[w]"}
    allWords = []string{"👨", "👨‍👩‍👦"}
    printResults(text, allOpts, allWords)

    text = "Argentina🧑🇦🇹  France👨🇫🇷  Germany🧔🇩🇪  Netherlands👨‍👩‍👦🇳🇱"
    allOpts = []string{"[p]", "[p|o]"}
    printResults(text, allOpts, allWords)
}
