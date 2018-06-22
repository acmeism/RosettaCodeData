package main

import (
    "bytes"
    "encoding/csv"
    "flag"
    "fmt"
    "html/template"
    "strings"
)

var csvStr = `Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!`

func main() {
    headings := flag.Bool("h", false, "format first row as column headings")
    flag.Parse()
    if html, err := csvToHtml(csvStr, *headings); err != nil {
        fmt.Println(err)
    } else {
        fmt.Print(html)
    }
}

func csvToHtml(csvStr string, headings bool) (string, error) {
    data, err := csv.NewReader(bytes.NewBufferString(csvStr)).ReadAll()
    if err != nil {
        return "", err
    }
    tStr := tPlain
    if headings {
        tStr = tHeadings
    }
    var b strings.Builder
    err = template.Must(template.New("").Parse(tStr)).Execute(&b, data)
    return b.String(), err
}

const (
    tPlain = `<table>
{{range .}}    <tr>{{range .}}<td>{{.}}</td>{{end}}</tr>
{{end}}</table>
`
    tHeadings = `<table>{{if .}}
{{range $x, $e := .}}{{if $x}}
      <tr>{{range .}}<td>{{.}}</td>{{end}}</tr>{{else}}   <thead>
      <tr>{{range .}}<th>{{.}}</th>{{end}}</tr>
   </thead>
   <tbody>{{end}}{{end}}
   </tbody>{{end}}
</table>
`
)
