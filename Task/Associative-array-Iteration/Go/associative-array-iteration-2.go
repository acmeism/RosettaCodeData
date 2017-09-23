package main

import (
    "os"
    "text/template"
)

func main() {
    m := map[string]int{
        "hello": 13,
        "world": 31,
        "!":     71,
    }

    // iterating over key-value pairs:
    template.Must(template.New("").Parse(`
{{- range $k, $v := . -}}
key = {{$k}}, value = {{$v}}
{{end -}}
`)).Execute(os.Stdout, m)

    // iterating over keys:
    template.Must(template.New("").Parse(`
{{- range $k, $v := . -}}
key = {{$k}}
{{end -}}
`)).Execute(os.Stdout, m)

    // iterating over values:
    template.Must(template.New("").Parse(`
{{- range . -}}
value = {{.}}
{{end -}}
`)).Execute(os.Stdout, m)
}
