package main

import (
    "fmt"
    "log"
)

var endings = [][]string{
    {"o", "as", "at", "amus", "atis", "ant"},
    {"eo", "es", "et", "emus", "etis", "ent"},
    {"o", "is", "it", "imus", "itis", "unt"},
    {"io", "is", "it", "imus", "itis", "iunt"},
}

var infinEndings = []string{"are", "ēre", "ere", "ire"}

var pronouns = []string{"I", "you (singular)", "he, she or it", "we", "you (plural)", "they"}

var englishEndings = []string{"", "", "s", "", "", ""}

func conjugate(infinitive, english string) {
    letters := []rune(infinitive)
    le := len(letters)
    if le < 4 {
        log.Fatal("Infinitive is too short for a regular verb.")
    }
    infinEnding := string(letters[le-3:])
    conj := -1
    for i, s := range infinEndings {
        if s == infinEnding {
            conj = i
            break
        }
    }
    if conj == -1 {
        log.Fatalf("Infinitive ending -%s not recognized.", infinEnding)
    }
    stem := string(letters[:le-3])
    fmt.Printf("Present indicative tense, active voice, of '%s' to '%s':\n", infinitive, english)
    for i, ending := range endings[conj] {
        fmt.Printf("    %s%-4s  %s %s%s\n", stem, ending, pronouns[i], english, englishEndings[i])
    }
    fmt.Println()
}

func main() {
    pairs := [][2]string{{"amare", "love"}, {"vidēre", "see"}, {"ducere", "lead"}, {"audire", "hear"}}
    for _, pair := range pairs {
        conjugate(pair[0], pair[1])
    }
}
