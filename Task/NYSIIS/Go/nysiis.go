package main

import (
    "fmt"
    "strings"
)

type pair struct{ first, second string }

var (
    fStrs = []pair{{"MAC", "MCC"}, {"KN", "N"}, {"K", "C"}, {"PH", "FF"},
        {"PF", "FF"}, {"SCH", "SSS"}}
    lStrs = []pair{{"EE", "Y"}, {"IE", "Y"}, {"DT", "D"}, {"RT", "D"},
        {"RD", "D"}, {"NT", "D"}, {"ND", "D"}}
    mStrs = []pair{{"EV", "AF"}, {"KN", "N"}, {"SCH", "SSS"}, {"PH", "FF"}}
    eStrs = []string{"JR", "JNR", "SR", "SNR"}
)

func isVowel(b byte) bool {
    return strings.ContainsRune("AEIOU", rune(b))
}

func isRoman(s string) bool {
    if s == "" {
        return false
    }
    for _, r := range s {
        if !strings.ContainsRune("IVX", r) {
            return false
        }
    }
    return true
}

func nysiis(word string) string {
    if word == "" {
        return ""
    }
    w := strings.ToUpper(word)
    ww := strings.FieldsFunc(w, func(r rune) bool {
        return r == ' ' || r == ','
    })
    if len(ww) > 1 {
        last := ww[len(ww)-1]
        if isRoman(last) {
            w = w[:len(w)-len(last)]
        }
    }
    for _, c := range " ,'-" {
        w = strings.Replace(w, string(c), "", -1)
    }
    for _, eStr := range eStrs {
        if strings.HasSuffix(w, eStr) {
            w = w[:len(w)-len(eStr)]
        }
    }
    for _, fStr := range fStrs {
        if strings.HasPrefix(w, fStr.first) {
            w = strings.Replace(w, fStr.first, fStr.second, 1)
        }
    }
    for _, lStr := range lStrs {
        if strings.HasSuffix(w, lStr.first) {
            w = w[:len(w)-2] + lStr.second
        }
    }
    initial := w[0]
    var key strings.Builder
    key.WriteByte(initial)
    w = w[1:]
    for _, mStr := range mStrs {
        w = strings.Replace(w, mStr.first, mStr.second, -1)
    }
    sb := []byte{initial}
    sb = append(sb, w...)
    le := len(sb)
    for i := 1; i < le; {
        switch sb[i] {
        case 'E', 'I', 'O', 'U':
            sb[i] = 'A'
        case 'Q':
            sb[i] = 'G'
        case 'Z':
            sb[i] = 'S'
        case 'M':
            sb[i] = 'N'
        case 'K':
            sb[i] = 'C'
        case 'H':
            if !isVowel(sb[i-1]) || (i < le-1 && !isVowel(sb[i+1])) {
                sb[i] = sb[i-1]
            }
        case 'W':
            if isVowel(sb[i-1]) {
                sb[i] = 'A'
            }
        }
        if sb[i] == sb[i-1] {
            sb = append(sb[:i], sb[i+1:]...)
            le--
        } else {
            i++
        }
    }
    if sb[le-1] == 'S' {
        sb = sb[:le-1]
        le--
    }
    if le > 1 && string(sb[le-2:]) == "AY" {
        sb = sb[:le-2]
        sb = append(sb, 'Y')
        le--
    }
    if le > 0 && sb[le-1] == 'A' {
        sb = sb[:le-1]
        le--
    }
    prev := initial
    for j := 1; j < le; j++ {
        c := sb[j]
        if prev != c {
            key.WriteByte(c)
            prev = c
        }
    }
    return key.String()
}

func main() {
    names := []string{
        "Bishop", "Carlson", "Carr", "Chapman",
        "Franklin", "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
        "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews", "May jnr",
        "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
        "O'Banion", "O'Brien", "Richards", "Silva", "Watkins", "Xi",
        "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
        "knight", "mitchell", "o'daniel", "bevan", "evans", "D'Souza",
        "Hoyle-Johnson", "Vaughan Williams", "de Sousa", "de la Mare II",
    }
    for _, name := range names {
        name2 := nysiis(name)
        if len(name2) > 6 {
            name2 = fmt.Sprintf("%s(%s)", name2[:6], name2[6:])
        }
        fmt.Printf("%-16s : %s\n", name, name2)
    }
}
