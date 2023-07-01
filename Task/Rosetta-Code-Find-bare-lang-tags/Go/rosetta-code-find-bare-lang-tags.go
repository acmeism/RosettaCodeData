package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "os"
    "regexp"
    "strings"
)

type header struct {
    start, end int
    lang       string
}

type data struct {
    count int
    names *[]string
}

func newData(count int, name string) *data {
    return &data{count, &[]string{name}}
}

var bmap = make(map[string]*data)

func add2bmap(lang, name string) {
    pd := bmap[lang]
    if pd != nil {
        pd.count++
        *pd.names = append(*pd.names, name)
    } else {
        bmap[lang] = newData(1, name)
    }
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    expr := `==\s*{{\s*header\s*\|\s*([^\s\}]+)\s*}}\s*==`
    expr2 := fmt.Sprintf("<%s>.*?</%s>", "lang", "lang")
    r := regexp.MustCompile(expr)
    r2 := regexp.MustCompile(expr2)
    fileNames := []string{"example.txt", "example2.txt", "example3.txt"}
    for _, fileName := range fileNames {
        f, err := os.Open(fileName)
        check(err)
        b, err := ioutil.ReadAll(f)
        check(err)
        f.Close()
        text := string(b)
        fmt.Printf("Contents of %s:\n\n%s\n\n", fileName, text)
        m := r.FindAllStringIndex(text, -1)
        headers := make([]header, len(m))
        if len(m) > 0 {
            for i, p := range m {
                headers[i] = header{p[0], p[1] - 1, ""}
            }
            m2 := r.FindAllStringSubmatch(text, -1)
            for i, s := range m2 {
                headers[i].lang = strings.ToLower(s[1])
            }
        }
        last := len(headers) - 1
        if last == -1 { // if there are no headers in the file add a dummy one
            headers = append(headers, header{-1, -1, "no language"})
            last = 0
        }
        m3 := r2.FindAllStringIndex(text, -1)
        for _, p := range m3 {
            if p[1] < headers[0].start {
                add2bmap("no language", fileName)
            } else if p[0] > headers[last].end {
                add2bmap(headers[last].lang, fileName)
            } else {
                for i := 0; i < last; i++ {
                    if p[0] > headers[i].end && p[0] < headers[i+1].start {
                        add2bmap(headers[i].lang, fileName)
                        break
                    }
                }
            }
        }
    }
    fmt.Println("Results:\n")
    count := 0
    for _, v := range bmap {
        count += v.count
    }
    fmt.Printf(" %d bare language tags.\n\n", count)
    for k, v := range bmap {
        fmt.Printf("  %d in %-11s %v\n", v.count, k, *v.names)
    }
}
