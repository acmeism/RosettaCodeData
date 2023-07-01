package main

import(
    "bufio"
    "fmt"
    "os"
    "strings"
)

func distinctStrings(strs []string) []string {
    len := len(strs)
    set := make(map[string]bool, len)
    distinct := make([]string, 0, len)
    for _, str := range strs {
        if !set[str] {
            distinct = append(distinct, str)
            set[str] = true
        }
    }
    return distinct
}

func takeRunes(s string, n int) string {
    i := 0
    for j := range s {
        if i == n {
            return s[:j]
        }
        i++
    }
    return s
}

func main() {
    file, err := os.Open("days_of_week.txt")
    if err != nil {
        fmt.Println("Unable to open file.")
        return
    }
    defer file.Close()
    reader := bufio.NewReader(file)
    lineCount := 0
    for {
        line, err := reader.ReadString('\n')
        if err != nil { // end of file reached
            return
        }
        line = strings.TrimSpace(line)
        lineCount++
        if line == "" {
            fmt.Println()
            continue
        }
        days := strings.Fields(line)
        daysLen := len(days)
        if (len(days) != 7) {
            fmt.Println("There aren't 7 days in line", lineCount)
            return
        }
        if len(distinctStrings(days)) != 7 { // implies some days have the same name
            fmt.Println(" ∞ ", line)
            continue
        }
        for abbrevLen := 1; ; abbrevLen++ {
            abbrevs := make([]string, daysLen)
            for i := 0; i < daysLen; i++ {
                abbrevs[i] = takeRunes(days[i], abbrevLen)
            }
            if len(distinctStrings(abbrevs)) == 7 {
                fmt.Printf("%2d  %s\n", abbrevLen, line)
                break
            }
        }
    }
}
