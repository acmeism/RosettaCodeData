package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "regexp"
    "sort"
    "strconv"
)

type Result struct {
    lang  string
    users int
}

func main() {
    const minimum = 25
    ex := `"Category:(.+?)( User)?"(\}|,"categoryinfo":\{"size":(\d+),)`
    re := regexp.MustCompile(ex)
    page := "http://rosettacode.org/mw/api.php?"
    action := "action=query"
    format := "format=json"
    fversion := "formatversion=2"
    generator := "generator=categorymembers"
    gcmTitle := "gcmtitle=Category:Language%20users"
    gcmLimit := "gcmlimit=500"
    prop := "prop=categoryinfo"
    rawContinue := "rawcontinue="
    page += fmt.Sprintf("%s&%s&%s&%s&%s&%s&%s&%s", action, format, fversion,
        generator, gcmTitle, gcmLimit, prop, rawContinue)
    resp, _ := http.Get(page)
    body, _ := ioutil.ReadAll(resp.Body)
    matches := re.FindAllStringSubmatch(string(body), -1)
    resp.Body.Close()
    var results []Result
    for _, match := range matches {
        if len(match) == 5 {
            users, _ := strconv.Atoi(match[4])
            if users >= minimum {
                result := Result{match[1], users}
                results = append(results, result)
            }
        }
    }
    sort.Slice(results, func(i, j int) bool {
        return results[j].users < results[i].users
    })

    fmt.Println("Rank  Users  Language")
    fmt.Println("----  -----  --------")
    rank := 0
    lastUsers := 0
    lastRank := 0
    for i, result := range results {
        eq := " "
        rank = i + 1
        if lastUsers == result.users {
            eq = "="
            rank = lastRank
        } else {
            lastUsers = result.users
            lastRank = rank
        }
        fmt.Printf(" %-2d%s   %3d    %s\n", rank, eq, result.users, result.lang)
    }
}
