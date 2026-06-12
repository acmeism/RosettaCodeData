package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "regexp"
    "sort"
    "strings"
)

type authorNumber struct {
    author string
    number int
}

func main() {
    ex1 := `<li><a href="/wiki/(.*?)"`
    ex2 := `a href="/(wiki/User:|mw/index\.php\?title=User:|wiki/Special:Contributions/)([^"&]+)`
    re1 := regexp.MustCompile(ex1)
    re2 := regexp.MustCompile(ex2)
    url1 := "http://rosettacode.org/wiki/Category:Programming_Tasks"
    url2 := "http://rosettacode.org/wiki/Category:Draft_Programming_Tasks"
    urls := []string{url1, url2}
    var tasks []string
    for _, url := range urls {
        resp, _ := http.Get(url)
        body, _ := ioutil.ReadAll(resp.Body)
        // find all tasks
        matches := re1.FindAllStringSubmatch(string(body), -1)
        resp.Body.Close()
        for _, match := range matches {
            // exclude any 'category' references
            if !strings.HasPrefix(match[1], "Category:") {
                tasks = append(tasks, match[1])
            }
        }
    }
    authors := make(map[string]int)
    for _, task := range tasks {
        // check the last or only history page for each task
        page := fmt.Sprintf("http://rosettacode.org/mw/index.php?title=%s&dir=prev&action=history", task)
        resp, _ := http.Get(page)
        body, _ := ioutil.ReadAll(resp.Body)
        // find all the users in that page
        matches := re2.FindAllStringSubmatch(string(body), -1)
        resp.Body.Close()
        //  the task author should be the final user on that page
        author := matches[len(matches)-1][2]
        author = strings.ReplaceAll(author, "_", " ")
        // add this task to the author's count
        authors[author]++
    }
    // sort the authors in descending order by number of tasks created
    authorNumbers := make([]authorNumber, 0, len(authors))
    for k, v := range authors {
        authorNumbers = append(authorNumbers, authorNumber{k, v})
    }
    sort.Slice(authorNumbers, func(i, j int) bool {
        return authorNumbers[i].number > authorNumbers[j].number
    })
    // print the top twenty say
    fmt.Println("Total tasks   :", len(tasks))
    fmt.Println("Total authors :", len(authors))
    fmt.Println("\nThe top 20 authors by number of tasks created are:\n")
    fmt.Println("Pos  Tasks  Author")
    fmt.Println("===  =====  ======")
    lastNumber, lastIndex := 0, -1
    for i, authorNumber := range authorNumbers[0:20] {
        j := i
        if authorNumber.number == lastNumber {
            j = lastIndex
        } else {
            lastIndex = i
            lastNumber = authorNumber.number
        }
        fmt.Printf("%2d:   %3d   %s\n", j+1, authorNumber.number, authorNumber.author)
    }
}
