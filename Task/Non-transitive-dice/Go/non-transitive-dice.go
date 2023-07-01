package main

import (
    "fmt"
    "sort"
)

func fourFaceCombs() (res [][4]int) {
    found := make([]bool, 256)
    for i := 1; i <= 4; i++ {
        for j := 1; j <= 4; j++ {
            for k := 1; k <= 4; k++ {
                for l := 1; l <= 4; l++ {
                    c := [4]int{i, j, k, l}
                    sort.Ints(c[:])
                    key := 64*(c[0]-1) + 16*(c[1]-1) + 4*(c[2]-1) + (c[3] - 1)
                    if !found[key] {
                        found[key] = true
                        res = append(res, c)
                    }
                }
            }
        }
    }
    return
}

func cmp(x, y [4]int) int {
    xw := 0
    yw := 0
    for i := 0; i < 4; i++ {
        for j := 0; j < 4; j++ {
            if x[i] > y[j] {
                xw++
            } else if y[j] > x[i] {
                yw++
            }
        }
    }
    if xw < yw {
        return -1
    } else if xw > yw {
        return 1
    }
    return 0
}

func findIntransitive3(cs [][4]int) (res [][3][4]int) {
    var c = len(cs)
    for i := 0; i < c; i++ {
        for j := 0; j < c; j++ {
            for k := 0; k < c; k++ {
                first := cmp(cs[i], cs[j])
                if first == -1 {
                    second := cmp(cs[j], cs[k])
                    if second == -1 {
                        third := cmp(cs[i], cs[k])
                        if third == 1 {
                            res = append(res, [3][4]int{cs[i], cs[j], cs[k]})
                        }
                    }
                }
            }
        }
    }
    return
}

func findIntransitive4(cs [][4]int) (res [][4][4]int) {
    c := len(cs)
    for i := 0; i < c; i++ {
        for j := 0; j < c; j++ {
            for k := 0; k < c; k++ {
                for l := 0; l < c; l++ {
                    first := cmp(cs[i], cs[j])
                    if first == -1 {
                        second := cmp(cs[j], cs[k])
                        if second == -1 {
                            third := cmp(cs[k], cs[l])
                            if third == -1 {
                                fourth := cmp(cs[i], cs[l])
                                if fourth == 1 {
                                    res = append(res, [4][4]int{cs[i], cs[j], cs[k], cs[l]})
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return
}

func main() {
    combs := fourFaceCombs()
    fmt.Println("Number of eligible 4-faced dice", len(combs))
    it3 := findIntransitive3(combs)
    fmt.Printf("\n%d ordered lists of 3 non-transitive dice found, namely:\n", len(it3))
    for _, a := range it3 {
        fmt.Println(a)
    }
    it4 := findIntransitive4(combs)
    fmt.Printf("\n%d ordered lists of 4 non-transitive dice found, namely:\n", len(it4))
    for _, a := range it4 {
        fmt.Println(a)
    }
}
