package main

import (
    "fmt"
    "golang.org/x/net/html"
    "io/ioutil"
    "net/http"
    "regexp"
    "strings"
)

var (
    expr = `<h3 class="title"><a class=.*?href="(.*?)".*?>(.*?)</a></h3>` +
        `.*?<div class="compText aAbs" ><p class=.*?>(.*?)</p></div>`
    rx = regexp.MustCompile(expr)
)

type YahooResult struct {
    title, url, content string
}

func (yr YahooResult) String() string {
    return fmt.Sprintf("Title  : %s\nUrl    : %s\nContent: %s\n", yr.title, yr.url, yr.content)
}

type YahooSearch struct {
    query string
    page  int
}

func (ys YahooSearch) results() []YahooResult {
    search := fmt.Sprintf("http://search.yahoo.com/search?p=%s&b=%d", ys.query, ys.page*10+1)
    resp, _ := http.Get(search)
    body, _ := ioutil.ReadAll(resp.Body)
    s := string(body)
    defer resp.Body.Close()
    var results []YahooResult
    for _, f := range rx.FindAllStringSubmatch(s, -1) {
        yr := YahooResult{}
        yr.title = html.UnescapeString(strings.ReplaceAll(strings.ReplaceAll(f[2], "<b>", ""), "</b>", ""))
        yr.url = f[1]
        yr.content = html.UnescapeString(strings.ReplaceAll(strings.ReplaceAll(f[3], "<b>", ""), "</b>", ""))
        results = append(results, yr)
    }
    return results
}

func (ys YahooSearch) nextPage() YahooSearch {
    return YahooSearch{ys.query, ys.page + 1}
}

func main() {
    ys := YahooSearch{"rosettacode", 0}
    // Limit output to first 5 entries, say, from pages 1 and 2.
    fmt.Println("PAGE 1 =>\n")
    for _, res := range ys.results()[0:5] {
        fmt.Println(res)
    }
    fmt.Println("PAGE 2 =>\n")
    for _, res := range ys.nextPage().results()[0:5] {
        fmt.Println(res)
    }
}
