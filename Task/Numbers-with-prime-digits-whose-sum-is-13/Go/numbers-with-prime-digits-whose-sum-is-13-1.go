package main

import (
    "fmt"
    "sort"
    "strconv"
)

func combrep(n int, lst []byte) [][]byte {
    if n == 0 {
        return [][]byte{nil}
    }
    if len(lst) == 0 {
        return nil
    }
    r := combrep(n, lst[1:])
    for _, x := range combrep(n-1, lst) {
        r = append(r, append(x, lst[0]))
    }
    return r
}

func shouldSwap(s []byte, start, curr int) bool {
    for i := start; i < curr; i++ {
        if s[i] == s[curr] {
            return false
        }
    }
    return true
}

func findPerms(s []byte, index, n int, res *[]string) {
    if index >= n {
        *res = append(*res, string(s))
        return
    }
    for i := index; i < n; i++ {
        check := shouldSwap(s, index, i)
        if check {
            s[index], s[i] = s[i], s[index]
            findPerms(s, index+1, n, res)
            s[index], s[i] = s[i], s[index]
        }
    }
}

func main() {
    primes := []byte{2, 3, 5, 7}
    var res []string
    for n := 3; n <= 6; n++ {
        reps := combrep(n, primes)
        for _, rep := range reps {
            sum := byte(0)
            for _, r := range rep {
                sum += r
            }
            if sum == 13 {
                var perms []string
                for i := 0; i < len(rep); i++ {
                    rep[i] += 48
                }
                findPerms(rep, 0, len(rep), &perms)
                res = append(res, perms...)
            }
        }
    }
    res2 := make([]int, len(res))
    for i, r := range res {
        res2[i], _ = strconv.Atoi(r)
    }
    sort.Ints(res2)
    fmt.Println("Those numbers whose digits are all prime and sum to 13 are:")
    fmt.Println(res2)
}
