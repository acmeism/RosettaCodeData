package main

import (
    "math"
    "os"
    "strconv"
    "text/template"
)

func sqr(x string) string {
    f, err := strconv.ParseFloat(x, 64)
    if err != nil {
        return "NA"
    }
    return strconv.FormatFloat(f*f, 'f', -1, 64)
}

func sqrt(x string) string {
    f, err := strconv.ParseFloat(x, 64)
    if err != nil {
        return "NA"
    }
    return strconv.FormatFloat(math.Sqrt(f), 'f', -1, 64)
}

func main() {
    f := template.FuncMap{"sqr": sqr, "sqrt": sqrt}
    t := template.Must(template.New("").Funcs(f).Parse(`. = {{.}}
square: {{sqr .}}
square root: {{sqrt .}}
`))
    t.Execute(os.Stdout, "3")
}
