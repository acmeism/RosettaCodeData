package main

import (
    "fmt"
    "html"
    "regexp"
    "strings"
)

var t = `     Sample Text

This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.

* This is a bulleted list with a less than sign (<)

* And this is its second line with a greater than sign (>)

A 'normal' paragraph between the lists.

1. This is a numbered list with an ampersand (&)

2. "Second line" in double quotes

3. 'Third line' in single quotes

That's all folks.`

func main() {
    p := regexp.MustCompile(`\n\s*(\n\s*)+`)
    ul := regexp.MustCompile(`^\*`)
    ol := regexp.MustCompile(`^\d\.`)
    t = html.EscapeString(t) // escape <, >, &, " and '
    paras := p.Split(t, -1)

    // Assume if first character of first paragraph is white-space
    // then it's probably a document title.
    firstChar := paras[0][0]
    title := "Untitled"
    k := 0
    if firstChar == ' ' || firstChar == '\t' {
        title = strings.TrimSpace(paras[0])
        k = 1
    }
    fmt.Println("<html>")
    fmt.Printf("<head><title>%s</title></head>\n", title)
    fmt.Println("<body>")

    blist := false
    nlist := false
    for _, para := range paras[k:] {
        para2 := strings.TrimSpace(para)

        if ul.MatchString(para2) {
            if !blist {
                blist = true
                fmt.Println("<ul>")
            }
            para2 = strings.TrimSpace(para2[1:])
            fmt.Printf("  <li>%s</li>\n", para2)
            continue
        } else if blist {
            blist = false
            fmt.Println("</ul>")
        }

        if ol.MatchString(para2) {
            if !nlist {
                nlist = true
                fmt.Println("<ol>")
            }
            para2 = strings.TrimSpace(para2[2:])
            fmt.Printf("  <li>%s</li>\n", para2)
            continue
        } else if nlist {
            nlist = false
            fmt.Println("</ol>")
        }

        if !blist && !nlist {
            fmt.Printf("<p>%s</p>\n", para2)
        }
    }
    if blist {
        fmt.Println("</ul>")
    }
    if nlist {
        fmt.Println("</ol>")
    }
    fmt.Println("</body>")
    fmt.Println("</html>")
}
