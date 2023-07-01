package main

import (
    "fmt"
    "sort"
)

func permute(s string) []string {
    var res []string
    if len(s) == 0 {
        return res
    }
    b := []byte(s)
    var rc func(int) // recursive closure
    rc = func(np int) {
        if np == 1 {
            res = append(res, string(b))
            return
        }
        np1 := np - 1
        pp := len(b) - np1
        rc(np1)
        for i := pp; i > 0; i-- {
            b[i], b[i-1] = b[i-1], b[i]
            rc(np1)
        }
        w := b[0]
        copy(b, b[1:pp+1])
        b[pp] = w
    }
    rc(len(b))
    return res
}

func algorithm1(nums []string) {
    fmt.Println("Algorithm 1")
    fmt.Println("-----------")
    for _, num := range nums {
        perms := permute(num)
        le := len(perms)
        if le == 0 { // ignore blanks
            continue
        }
        sort.Strings(perms)
        ix := sort.SearchStrings(perms, num)
        next := ""
        if ix < le-1 {
            for i := ix + 1; i < le; i++ {
                if perms[i] > num {
                    next = perms[i]
                    break
                }
            }
        }
        if len(next) > 0 {
            fmt.Printf("%29s -> %s\n", commatize(num), commatize(next))
        } else {
            fmt.Printf("%29s -> 0\n", commatize(num))
        }
    }
    fmt.Println()
}

func algorithm2(nums []string) {
    fmt.Println("Algorithm 2")
    fmt.Println("-----------")
outer:
    for _, num := range nums {
        b := []byte(num)
        le := len(b)
        if le == 0 { // ignore blanks
            continue
        }
        max := num[le-1]
        mi := le - 1
        for i := le - 2; i >= 0; i-- {
            if b[i] < max {
                min := max - b[i]
                for j := mi + 1; j < le; j++ {
                    min2 := b[j] - b[i]
                    if min2 > 0 && min2 < min {
                        min = min2
                        mi = j
                    }
                }
                b[i], b[mi] = b[mi], b[i]
                c := (b[i+1:])
                sort.Slice(c, func(i, j int) bool {
                    return c[i] < c[j]
                })
                next := string(b[0:i+1]) + string(c)
                fmt.Printf("%29s -> %s\n", commatize(num), commatize(next))
                continue outer
            } else if b[i] > max {
                max = num[i]
                mi = i
            }
        }
        fmt.Printf("%29s -> 0\n", commatize(num))
    }
}

func commatize(s string) string {
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    nums := []string{"0", "9", "12", "21", "12453", "738440", "45072010", "95322020", "9589776899767587796600"}
    algorithm1(nums[:len(nums)-1]) // exclude the last one
    algorithm2(nums)               // include the last one
}
