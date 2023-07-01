package main

import (
    "fmt"
    "strconv"
)

func fusc(n int) []int {
    if n <= 0 {
        return []int{}
    }
    if n == 1 {
        return []int{0}
    }
    res := make([]int, n)
    res[0] = 0
    res[1] = 1
    for i := 2; i < n; i++ {
        if i%2 == 0 {
            res[i] = res[i/2]
        } else {
            res[i] = res[(i-1)/2] + res[(i+1)/2]
        }
    }
    return res
}

func fuscMaxLen(n int) [][2]int {
    maxLen := -1
    maxFusc := -1
    f := fusc(n)
    var res [][2]int
    for i := 0; i < n; i++ {
        if f[i] <= maxFusc {
            continue // avoid expensive strconv operation where possible
        }
        maxFusc = f[i]
        le := len(strconv.Itoa(f[i]))
        if le > maxLen {
            res = append(res, [2]int{i, f[i]})
            maxLen = le
        }
    }
    return res
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func main() {
    fmt.Println("The first 61 fusc numbers are:")
    fmt.Println(fusc(61))
    fmt.Println("\nThe fusc numbers whose length > any previous fusc number length are:")
    res := fuscMaxLen(20000000)  // examine first twenty million numbers say
    for i := 0; i < len(res); i++ {
        fmt.Printf("%7s (index %10s)\n", commatize(res[i][1]), commatize(res[i][0]))
    }
}
