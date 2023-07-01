package main

import (
    "fmt"
    "math"
    "sort"
    "time"
)

type term struct {
    coeff    uint64
    ix1, ix2 int8
}

const maxDigits = 19

func toUint64(digits []int8, reverse bool) uint64 {
    sum := uint64(0)
    if !reverse {
        for i := 0; i < len(digits); i++ {
            sum = sum*10 + uint64(digits[i])
        }
    } else {
        for i := len(digits) - 1; i >= 0; i-- {
            sum = sum*10 + uint64(digits[i])
        }
    }
    return sum
}

func isSquare(n uint64) bool {
    if 0x202021202030213&(1<<(n&63)) != 0 {
        root := uint64(math.Sqrt(float64(n)))
        return root*root == n
    }
    return false
}

func seq(from, to, step int8) []int8 {
    var res []int8
    for i := from; i <= to; i += step {
        res = append(res, i)
    }
    return res
}

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    start := time.Now()
    pow := uint64(1)
    fmt.Println("Aggregate timings to process all numbers up to:")
    // terms of (n-r) expression for number of digits from 2 to maxDigits
    allTerms := make([][]term, maxDigits-1)
    for r := 2; r <= maxDigits; r++ {
        var terms []term
        pow *= 10
        pow1, pow2 := pow, uint64(1)
        for i1, i2 := int8(0), int8(r-1); i1 < i2; i1, i2 = i1+1, i2-1 {
            terms = append(terms, term{pow1 - pow2, i1, i2})
            pow1 /= 10
            pow2 *= 10
        }
        allTerms[r-2] = terms
    }
    //  map of first minus last digits for 'n' to pairs giving this value
    fml := map[int8][][]int8{
        0: {{2, 2}, {8, 8}},
        1: {{6, 5}, {8, 7}},
        4: {{4, 0}},
        6: {{6, 0}, {8, 2}},
    }
    // map of other digit differences for 'n' to pairs giving this value
    dmd := make(map[int8][][]int8)
    for i := int8(0); i < 100; i++ {
        a := []int8{i / 10, i % 10}
        d := a[0] - a[1]
        dmd[d] = append(dmd[d], a)
    }
    fl := []int8{0, 1, 4, 6}
    dl := seq(-9, 9, 1) // all differences
    zl := []int8{0}     // zero differences only
    el := seq(-8, 8, 2) // even differences only
    ol := seq(-9, 9, 2) // odd differences only
    il := seq(0, 9, 1)
    var rares []uint64
    lists := make([][][]int8, 4)
    for i, f := range fl {
        lists[i] = [][]int8{{f}}
    }
    var digits []int8
    count := 0

    // Recursive closure to generate (n+r) candidates from (n-r) candidates
    // and hence find Rare numbers with a given number of digits.
    var fnpr func(cand, di []int8, dis [][]int8, indices [][2]int8, nmr uint64, nd, level int)
    fnpr = func(cand, di []int8, dis [][]int8, indices [][2]int8, nmr uint64, nd, level int) {
        if level == len(dis) {
            digits[indices[0][0]] = fml[cand[0]][di[0]][0]
            digits[indices[0][1]] = fml[cand[0]][di[0]][1]
            le := len(di)
            if nd%2 == 1 {
                le--
                digits[nd/2] = di[le]
            }
            for i, d := range di[1:le] {
                digits[indices[i+1][0]] = dmd[cand[i+1]][d][0]
                digits[indices[i+1][1]] = dmd[cand[i+1]][d][1]
            }
            r := toUint64(digits, true)
            npr := nmr + 2*r
            if !isSquare(npr) {
                return
            }
            count++
            fmt.Printf("     R/N %2d:", count)
            ms := uint64(time.Since(start).Milliseconds())
            fmt.Printf("  %9s ms", commatize(ms))
            n := toUint64(digits, false)
            fmt.Printf("  (%s)\n", commatize(n))
            rares = append(rares, n)
        } else {
            for _, num := range dis[level] {
                di[level] = num
                fnpr(cand, di, dis, indices, nmr, nd, level+1)
            }
        }
    }

    // Recursive closure to generate (n-r) candidates with a given number of digits.
    var fnmr func(cand []int8, list [][]int8, indices [][2]int8, nd, level int)
    fnmr = func(cand []int8, list [][]int8, indices [][2]int8, nd, level int) {
        if level == len(list) {
            var nmr, nmr2 uint64
            for i, t := range allTerms[nd-2] {
                if cand[i] >= 0 {
                    nmr += t.coeff * uint64(cand[i])
                } else {
                    nmr2 += t.coeff * uint64(-cand[i])
                    if nmr >= nmr2 {
                        nmr -= nmr2
                        nmr2 = 0
                    } else {
                        nmr2 -= nmr
                        nmr = 0
                    }
                }
            }
            if nmr2 >= nmr {
                return
            }
            nmr -= nmr2
            if !isSquare(nmr) {
                return
            }
            var dis [][]int8
            dis = append(dis, seq(0, int8(len(fml[cand[0]]))-1, 1))
            for i := 1; i < len(cand); i++ {
                dis = append(dis, seq(0, int8(len(dmd[cand[i]]))-1, 1))
            }
            if nd%2 == 1 {
                dis = append(dis, il)
            }
            di := make([]int8, len(dis))
            fnpr(cand, di, dis, indices, nmr, nd, 0)
        } else {
            for _, num := range list[level] {
                cand[level] = num
                fnmr(cand, list, indices, nd, level+1)
            }
        }
    }

    for nd := 2; nd <= maxDigits; nd++ {
        digits = make([]int8, nd)
        if nd == 4 {
            lists[0] = append(lists[0], zl)
            lists[1] = append(lists[1], ol)
            lists[2] = append(lists[2], el)
            lists[3] = append(lists[3], ol)
        } else if len(allTerms[nd-2]) > len(lists[0]) {
            for i := 0; i < 4; i++ {
                lists[i] = append(lists[i], dl)
            }
        }
        var indices [][2]int8
        for _, t := range allTerms[nd-2] {
            indices = append(indices, [2]int8{t.ix1, t.ix2})
        }
        for _, list := range lists {
            cand := make([]int8, len(list))
            fnmr(cand, list, indices, nd, 0)
        }
        ms := uint64(time.Since(start).Milliseconds())
        fmt.Printf("  %2d digits:  %9s ms\n", nd, commatize(ms))
    }

    sort.Slice(rares, func(i, j int) bool { return rares[i] < rares[j] })
    fmt.Printf("\nThe rare numbers with up to %d digits are:\n", maxDigits)
    for i, rare := range rares {
        fmt.Printf("  %2d:  %25s\n", i+1, commatize(rare))
    }
}
