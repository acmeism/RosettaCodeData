package main

import (
    "fmt"
    "html"
    "io/ioutil"
    "net/http"
    "regexp"
    "strings"
    "time"
)

func main() {
    ex := `<li><a href="/wiki/(.*?)"`
    re := regexp.MustCompile(ex)
    page := "http://rosettacode.org/wiki/Category:Programming_Tasks"
    resp, _ := http.Get(page)
    body, _ := ioutil.ReadAll(resp.Body)
    matches := re.FindAllStringSubmatch(string(body), -1)
    resp.Body.Close()
    tasks := make([]string, len(matches))
    for i, match := range matches {
        tasks[i] = match[1]
    }
    const base = "http://rosettacode.org/wiki/"
    const limit = 3 // number of tasks to print out
    ex = `(?s)using any language you may know.</div>(.*?)<div id="toc"`
    ex2 := `</?[^>]*>` // to remove all tags including links
    re = regexp.MustCompile(ex)
    re2 := regexp.MustCompile(ex2)
    for i, task := range tasks {
        page = base + task
        resp, _ = http.Get(page)
        body, _ = ioutil.ReadAll(resp.Body)
        match := re.FindStringSubmatch(string(body))
        resp.Body.Close()
        text := html.UnescapeString(re2.ReplaceAllLiteralString(match[1], ""))
        fmt.Println(strings.Replace(task, "_", " ", -1), "\n", text)
        if i == limit-1 {
            break
        }
        time.Sleep(5 * time.Second) // wait 5 seconds before processing next task
    }
}
