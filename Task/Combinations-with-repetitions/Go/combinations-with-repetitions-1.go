package main

import "fmt"

func combrep(n int, lst []string) [][]string {
    if n == 0 {
        return [][]string{nil}
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

func main() {
    fmt.Println(combrep(2, []string{"iced", "jam", "plain"}))
    fmt.Println(len(combrep(3,
        []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})))
}
