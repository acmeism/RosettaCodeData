package main

import (
    "fmt"
    "math"
    "sort"
    "strings"
)

func sortedOutline(originalOutline []string, ascending bool) {
    outline := make([]string, len(originalOutline))
    copy(outline, originalOutline) // make copy in case we mutate it
    indent := ""
    del := "\x7f"
    sep := "\x00"
    var messages []string
    if strings.TrimLeft(outline[0], " \t") != outline[0] {
        fmt.Println("    outline structure is unclear")
        return
    }
    for i := 1; i < len(outline); i++ {
        line := outline[i]
        lc := len(line)
        if strings.HasPrefix(line, "  ") || strings.HasPrefix(line, " \t") || line[0] == '\t' {
            lc2 := len(strings.TrimLeft(line, " \t"))
            currIndent := line[0 : lc-lc2]
            if indent == "" {
                indent = currIndent
            } else {
                correctionNeeded := false
                if (strings.ContainsRune(currIndent, '\t') && !strings.ContainsRune(indent, '\t')) ||
                    (!strings.ContainsRune(currIndent, '\t') && strings.ContainsRune(indent, '\t')) {
                    m := fmt.Sprintf("corrected inconsistent whitespace use at line %q", line)
                    messages = append(messages, indent+m)
                    correctionNeeded = true
                } else if len(currIndent)%len(indent) != 0 {
                    m := fmt.Sprintf("corrected inconsistent indent width at line %q", line)
                    messages = append(messages, indent+m)
                    correctionNeeded = true
                }
                if correctionNeeded {
                    mult := int(math.Round(float64(len(currIndent)) / float64(len(indent))))
                    outline[i] = strings.Repeat(indent, mult) + line[lc-lc2:]
                }
            }
        }
    }
    levels := make([]int, len(outline))
    levels[0] = 1
    margin := ""
    for level := 1; ; level++ {
        allPos := true
        for i := 1; i < len(levels); i++ {
            if levels[i] == 0 {
                allPos = false
                break
            }
        }
        if allPos {
            break
        }
        mc := len(margin)
        for i := 1; i < len(outline); i++ {
            if levels[i] == 0 {
                line := outline[i]
                if strings.HasPrefix(line, margin) && line[mc] != ' ' && line[mc] != '\t' {
                    levels[i] = level
                }
            }
        }
        margin += indent
    }
    lines := make([]string, len(outline))
    lines[0] = outline[0]
    var nodes []string
    for i := 1; i < len(outline); i++ {
        if levels[i] > levels[i-1] {
            if len(nodes) == 0 {
                nodes = append(nodes, outline[i-1])
            } else {
                nodes = append(nodes, sep+outline[i-1])
            }
        } else if levels[i] < levels[i-1] {
            j := levels[i-1] - levels[i]
            nodes = nodes[0 : len(nodes)-j]
        }
        if len(nodes) > 0 {
            lines[i] = strings.Join(nodes, "") + sep + outline[i]
        } else {
            lines[i] = outline[i]
        }
    }
    if ascending {
        sort.Strings(lines)
    } else {
        maxLen := len(lines[0])
        for i := 1; i < len(lines); i++ {
            if len(lines[i]) > maxLen {
                maxLen = len(lines[i])
            }
        }
        for i := 0; i < len(lines); i++ {
            lines[i] = lines[i] + strings.Repeat(del, maxLen-len(lines[i]))
        }
        sort.Sort(sort.Reverse(sort.StringSlice(lines)))
    }
    for i := 0; i < len(lines); i++ {
        s := strings.Split(lines[i], sep)
        lines[i] = s[len(s)-1]
        if !ascending {
            lines[i] = strings.TrimRight(lines[i], del)
        }
    }
    if len(messages) > 0 {
        fmt.Println(strings.Join(messages, "\n"))
        fmt.Println()
    }
    fmt.Println(strings.Join(lines, "\n"))
}

func main() {
    outline := []string{
        "zeta",
        "    beta",
        "    gamma",
        "        lambda",
        "        kappa",
        "        mu",
        "    delta",
        "alpha",
        "    theta",
        "    iota",
        "    epsilon",
    }

    outline2 := make([]string, len(outline))
    for i := 0; i < len(outline); i++ {
        outline2[i] = strings.ReplaceAll(outline[i], "    ", "\t")
    }

    outline3 := []string{
        "alpha",
        "    epsilon",
        "        iota",
        "    theta",
        "zeta",
        "    beta",
        "    delta",
        "    gamma",
        "    \t   kappa", // same length but \t instead of space
        "        lambda",
        "        mu",
    }

    outline4 := []string{
        "zeta",
        "    beta",
        "   gamma",
        "        lambda",
        "         kappa",
        "        mu",
        "    delta",
        "alpha",
        "    theta",
        "    iota",
        "    epsilon",
    }

    fmt.Println("Four space indented outline, ascending sort:")
    sortedOutline(outline, true)

    fmt.Println("\nFour space indented outline, descending sort:")
    sortedOutline(outline, false)

    fmt.Println("\nTab indented outline, ascending sort:")
    sortedOutline(outline2, true)

    fmt.Println("\nTab indented outline, descending sort:")
    sortedOutline(outline2, false)

    fmt.Println("\nFirst unspecified outline, ascending sort:")
    sortedOutline(outline3, true)

    fmt.Println("\nFirst unspecified outline, descending sort:")
    sortedOutline(outline3, false)

    fmt.Println("\nSecond unspecified outline, ascending sort:")
    sortedOutline(outline4, true)

    fmt.Println("\nSecond unspecified outline, descending sort:")
    sortedOutline(outline4, false)
}
