package main

import (
    "bufio"
    "fmt"
    "golang.org/x/crypto/ssh/terminal"
    "log"
    "os"
    "regexp"
    "strconv"
)

type Color struct{ r, g, b int }

type ColorEx struct {
    color Color
    code  string
}

var colors = []ColorEx{
    {Color{15, 0, 0}, "31"},
    {Color{0, 15, 0}, "32"},
    {Color{15, 15, 0}, "33"},
    {Color{0, 0, 15}, "34"},
    {Color{15, 0, 15}, "35"},
    {Color{0, 15, 15}, "36"},
}

func squareDist(c1, c2 Color) int {
    xd := c2.r - c1.r
    yd := c2.g - c1.g
    zd := c2.b - c1.b
    return xd*xd + yd*yd + zd*zd
}

func printColor(s string) {
    n := len(s)
    k := 0
    for i := 0; i < n/3; i++ {
        j := i * 3
        c1 := s[j]
        c2 := s[j+1]
        c3 := s[j+2]
        k = j + 3
        r, err := strconv.ParseInt(fmt.Sprintf("0x%c", c1), 0, 64)
        check(err)
        g, err := strconv.ParseInt(fmt.Sprintf("0x%c", c2), 0, 64)
        check(err)
        b, err := strconv.ParseInt(fmt.Sprintf("0x%c", c3), 0, 64)
        check(err)
        rgb := Color{int(r), int(g), int(b)}
        m := 676
        colorCode := ""
        for _, cex := range colors {
            sqd := squareDist(cex.color, rgb)
            if sqd < m {
                colorCode = cex.code
                m = sqd
            }
        }
        fmt.Printf("\033[%s;1m%c%c%c\033[00m", colorCode, c1, c2, c3)
    }
    for j := k; j < n; j++ {
        c := s[j]
        fmt.Printf("\033[0;1m%c\033[00m", c)
    }
}

var (
    r       = regexp.MustCompile("^([A-Fa-f0-9]+)([ \t]+.+)$")
    scanner = bufio.NewScanner(os.Stdin)
    err     error
)

func colorChecksum() {
    for scanner.Scan() {
        line := scanner.Text()
        if r.MatchString(line) {
            submatches := r.FindStringSubmatch(line)
            s1 := submatches[1]
            s2 := submatches[2]
            printColor(s1)
            fmt.Println(s2)
        } else {
            fmt.Println(line)
        }
    }
    check(scanner.Err())
}

func cat() {
    for scanner.Scan() {
        line := scanner.Text()
        fmt.Println(line)
    }
    check(scanner.Err())
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    if terminal.IsTerminal(int(os.Stdout.Fd())) {
        colorChecksum()
    } else {
        cat()
    }
}
