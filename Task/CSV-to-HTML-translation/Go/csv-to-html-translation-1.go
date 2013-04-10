package main

import (
    "bytes"
    "encoding/csv"
    "fmt"
    "html/template"
)

var c = `Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!`

func main() {
    if h, err := csvToHtml(c); err != nil {
        fmt.Println(err)
    } else {
        fmt.Print(h)
    }
}

func csvToHtml(c string) (string, error) {
    data, err := csv.NewReader(bytes.NewBufferString(c)).ReadAll()
    if err != nil {
        return "", err
    }
    var b bytes.Buffer
    err = template.Must(template.New("").Parse(`<table>
{{range .}}    <tr>{{range .}}<td>{{.}}</td>{{end}}</tr>
{{end}}</table>
`)).Execute(&b, data)
    return b.String(), err
}
