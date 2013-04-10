package main

import (
    "fmt"
    "html/template"
    "os"
)

type row struct {
    X, Y, Z int
}

var tmpl = `<table>
    <tr><th></th><th>X</th><th>Y</th><th>Z</th></tr>
{{range $ix, $row := .}}    <tr><td>{{$ix}}</td>` +
    `<td>{{$row.X}}</td>` +
    `<td>{{$row.Y}}</td>` +
    `<td>{{$row.Z}}</td></tr>
{{end}}</table>
`

func main() {
    // create template
    ct := template.Must(template.New("").Parse(tmpl))

    // make up data
    data := make([]row, 4)
    for r := range data {
        data[r] = row{r*3, r*3+1, r*3+2}
    }

    // apply template to data
    if err := ct.Execute(os.Stdout, data); err != nil {
        fmt.Println(err)
    }
}
