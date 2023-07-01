package main

import (
    "fmt"
    "os"
    "sort"
    "strings"
    "text/template"
)

func main() {
    const t = `[[[{{index .P 1}}, {{index .P 2}}],
  [{{index .P 3}}, {{index .P 4}}, {{index .P 1}}],
  {{index .P 5}}]]
`
    type S struct {
        P map[int]string
    }

    var s S
    s.P = map[int]string{
        0: "'Payload#0'", 1: "'Payload#1'", 2: "'Payload#2'", 3: "'Payload#3'",
        4: "'Payload#4'", 5: "'Payload#5'", 6: "'Payload#6'",
    }
    tmpl := template.Must(template.New("").Parse(t))
    tmpl.Execute(os.Stdout, s)

    var unused []int
    for k, _ := range s.P {
        if !strings.Contains(t, fmt.Sprintf("{{index .P %d}}", k)) {
            unused = append(unused, k)
        }
    }
    sort.Ints(unused)
    fmt.Println("\nThe unused payloads have indices of :", unused)
}
