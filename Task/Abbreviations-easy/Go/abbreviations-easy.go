package main

import (
    "fmt"
    "strings"
)

var table =
    "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " +
    "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " +
    "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " +
     "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " +
    "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " +
    "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " +
    "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up "

func validate(commands, words []string, minLens []int) []string {
    results := make([]string, 0)
    if len(words) == 0 {
        return results
    }
    for _, word := range words {
        matchFound := false
        wlen := len(word)
        for i, command := range commands {
            if minLens[i] == 0 || wlen < minLens[i] || wlen > len(command) {
                continue
            }
            c := strings.ToUpper(command)
            w := strings.ToUpper(word)
            if strings.HasPrefix(c, w) {
                results = append(results, c)
                matchFound = true
                break
            }
        }
        if !matchFound {
            results = append(results, "*error*")
        }
    }
    return results
}

func main() {
    table = strings.TrimSpace(table)
    commands := strings.Fields(table)
    clen := len(commands)
    minLens := make([]int, clen)
    for i := 0; i < clen; i++ {
        count := 0
        for _, c := range commands[i] {
            if c >= 'A' && c <= 'Z' {
                count++
            }
        }
        minLens[i] = count
    }
    sentence :=  "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
    words := strings.Fields(sentence)
    results := validate(commands, words, minLens)
    fmt.Print("user words:  ")
    for j := 0; j < len(words); j++ {
        fmt.Printf("%-*s ", len(results[j]), words[j])
    }
    fmt.Print("\nfull words:  ")
    fmt.Println(strings.Join(results, " "))
}
