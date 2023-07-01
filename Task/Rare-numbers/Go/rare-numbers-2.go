package main

import (
    "fmt"
    "math"
    "sort"
    "time"
)

type llst = [][]int

var (
    d    []int     // permutation working slice
    drar [19]int   // digital root lookup array
    dac  []int     // running digital root slice
    p    [20]int64 // powers of 10
    ac   []int64   // accumulator slice
    pp   []int64   // coefficient slice that combines with digits of working slice
    sr   []int64   // temporary list of squares used for building
)

var (
    odd = false  // flag for odd number of digits
    sum int64    // calculated sum of terms (square candidate)
    rt  int64    // root of sum
    cn  = 0      // solution counter
    nd  = 2      // number of digits
    nd1 = nd - 1 // 'nd' helper
    ln  int      // previous value of 'n' (in recurse())
    dl  int      // length of 'd' slice
)

var (
    tlo = []int{0, 1, 4, 5, 6}                  // primary differences starting point
    all = seq(-9, 9, 1)                         // all possible differences
    odl = seq(-9, 9, 2)                         // odd possible differences
    evl = seq(-8, 8, 2)                         // even possible differences
    thi = []int{4, 5, 6, 9, 10, 11, 14, 15, 16} // primary sums starting point
    alh = seq(0, 18, 1)                         // all possible sums
    odh = seq(1, 17, 2)                         // odd possible sums
    evh = seq(0, 18, 2)                         // even possible sums
    ten = seq(0, 9, 1)                          // used for odd number of digits
    z   = seq(0, 0, 1)                          // no difference, avoids generating a bunch of negative square candidates
    t7  = []int{-3, 7}                          // shortcut for low 5
    nin = []int{9}                              // shortcut for hi 10
    tn  = []int{10}                             // shortcut for hi 0 (unused, unneeded)
    t12 = []int{2, 12}                          // shortcut for hi 5
    o11 = []int{1, 11}                          // shortcut for hi 15
    pos = []int{0, 1, 4, 5, 6, 9}               // shortcut for 2nd lo 0
)

var (
    lul = llst{z, odl, nil, nil, evl, t7, odl} // shortcut lookup lo primary
    luh = llst{tn, evh, nil, nil, evh, t12, odh, nil, nil, evh, nin, odh, nil, nil,
        odh, o11, evh} // shortcut lookup hi primary
    l2l = llst{pos, nil, nil, nil, all, nil, all} // shortcut lookup lo secondary
    l2h = llst{nil, nil, nil, nil, alh, nil, alh, nil, nil, nil, alh, nil, nil, nil,
        alh, nil, alh} // shortcut lookup hi secondary
    lu, l2 llst // ditto
    chTen  = llst{{0, 2, 5, 8, 9}, {0, 3, 4, 6, 9}, {1, 4, 7, 8}, {2, 3, 5, 8},
        {0, 3, 6, 7, 9}, {1, 2, 4, 7}, {2, 5, 6, 8}, {0, 1, 3, 6, 9}, {1, 4, 5, 7}}
    chAH = llst{{0, 2, 5, 8, 9, 11, 14, 17, 18}, {0, 3, 4, 6, 9, 12, 13, 15, 18}, {1, 4, 7, 8, 10, 13, 16, 17},
        {2, 3, 5, 8, 11, 12, 14, 17}, {0, 3, 6, 7, 9, 12, 15, 16, 18}, {1, 2, 4, 7, 10, 11, 13, 16},
        {2, 5, 6, 8, 11, 14, 15, 17}, {0, 1, 3, 6, 9, 10, 12, 15, 18}, {1, 4, 5, 7, 10, 13, 14, 16}}
)

// Returns a sequence of integers.
func seq(f, t, s int) []int {
    r := make([]int, (t-f)/s+1)
    for i := 0; i < len(r); i, f = i+1, f+s {
        r[i] = f
    }
    return r
}

// Returns Integer Square Root.
func isr(s int64) int64 {
    return int64(math.Sqrt(float64(s)))
}

// Recursively determines whether 'r' is the reverse of 'f'.
func isRev(nd int, f, r int64) bool {
    nd--
    if f/p[nd] != r%10 {
        return false
    }
    if nd < 1 {
        return true
    }
    return isRev(nd, f%p[nd], r/10)
}

// Recursive function to evaluate the permutations, no shortcuts.
func recurseLE5(lst llst, lv int) {
    if lv == dl { // check if on last stage of permutation
        sum = ac[lv-1]
        if sum > 0 {
            rt = int64(math.Sqrt(float64(sum)))
            if rt*rt == sum { // test accumulated sum, append to result if square
                sr = append(sr, sum)
            }
        }
    } else {
        for _, n := range lst[lv] { // set up next permutation
            d[lv] = n
            if lv == 0 {
                ac[0] = pp[0] * int64(n)
            } else {
                ac[lv] = ac[lv-1] + pp[lv]*int64(n) // update accumulated sum
            }
            recurseLE5(lst, lv+1) // recursively call next level
        }
    }
}

// Recursive function to evaluate the hi permutations, shortcuts added to avoid generating many non-squares, digital root calc added.
func recursehi(lst llst, lv int) {
    lv1 := lv - 1
    if lv == dl { // check if on last stage of permutation
        sum = ac[lv1]
        if (0x202021202030213 & (1 << (int(sum) & 63))) != 0 { // test accumulated sum, append to result if square
            rt = int64(math.Sqrt(float64(sum)))
            if rt*rt == sum {
                sr = append(sr, sum)
            }
        }
    } else {
        for _, n := range lst[lv] { // set up next permutation
            d[lv] = n
            if lv == 0 {
                ac[0] = pp[0] * int64(n)
                dac[0] = drar[n] // update accumulated sum and running dr
            } else {
                ac[lv] = ac[lv1] + pp[lv]*int64(n)
                dac[lv] = dac[lv1] + drar[n]
                if dac[lv] > 8 {
                    dac[lv] -= 9
                }
            }
            switch lv { // shortcuts to be performed on designated levels
            case 0: // primary level: set shortcuts for secondary level
                ln = n
                lst[1] = lu[ln]
                lst[2] = l2[n]
            case 1: // secondary level: set shortcuts for tertiary level
                switch ln { // for sums
                case 5, 15:
                    if n < 10 {
                        lst[2] = evh
                    } else {
                        lst[2] = odh
                    }
                case 9:
                    if ((n >> 1) & 1) == 0 {
                        lst[2] = evh
                    } else {
                        lst[2] = odh
                    }
                case 11:
                    if ((n >> 1) & 1) == 1 {
                        lst[2] = evh
                    } else {
                        lst[2] = odh
                    }
                }
            }
            if lv == dl-2 {
                // reduce last round according to dr calc
                if odd {
                    lst[dl-1] = chTen[dac[dl-2]]
                } else {
                    lst[dl-1] = chAH[dac[dl-2]]
                }
            }
            recursehi(lst, lv+1) // recursively call next level
        }
    }
}

// Recursive function to evaluate the lo permutations, shortcuts added to avoid
// generating many non-squares.
func recurselo(lst llst, lv int) {
    lv1 := lv - 1
    if lv == dl { // check if on last stage of permutation
        sum = ac[lv1]
        if sum > 0 {
            rt = int64(math.Sqrt(float64(sum)))
            if rt*rt == sum { // test accumulated sum, append to result if square
                sr = append(sr, sum)
            }
        }
    } else {
        for _, n := range lst[lv] { // set up next permutation
            d[lv] = n
            if lv == 0 {
                ac[0] = pp[0] * int64(n)
            } else {
                ac[lv] = ac[lv1] + pp[lv]*int64(n) // update accumulated sum
            }
            switch lv { // shortcuts to be performed on designated levels
            case 0: // primary level: set shortcuts for secondary level
                ln = n
                lst[1] = lu[ln]
                lst[2] = l2[n]
            case 1: // secondary level: set shortcuts for tertiary level
                switch ln { // for difs
                case 1:
                    if (((n + 9) >> 1) & 1) == 0 {
                        lst[2] = evl
                    } else {
                        lst[2] = odl
                    }
                case 5:
                    if n < 0 {
                        lst[2] = evl
                    } else {
                        lst[2] = odl
                    }
                }
            }
            recurselo(lst, lv+1) // Recursively call next level
        }
    }
}

// Produces a list of candidate square numbers.
func listEm(lst, plu, pl2 llst) []int64 {
    dl = len(lst)
    d = make([]int, dl)
    sr = sr[:0]
    lu = plu
    l2 = pl2
    ac = make([]int64, dl)
    dac = make([]int, dl) // init support vars
    pp = make([]int64, dl)
    for i, j := 0, nd1; i < dl; i, j = i+1, j-1 {
        // build coefficients array
        if len(lst[0]) > 6 {
            pp[i] = p[j] + p[i]
        } else {
            pp[i] = p[j] - p[i]
        }
    }
    // call appropriate recursive function
    if nd <= 5 {
        recurseLE5(lst, 0)
    } else if len(lst[0]) > 8 {
        recursehi(lst, 0)
    } else {
        recurselo(lst, 0)
    }
    return sr
}

// Reveals whether combining two lists of squares can produce a Rare number.
func reveal(lo, hi []int64) {
    var s []string // create temp list of results
    for _, l := range lo {
        for _, h := range hi {
            r := (h - l) >> 1
            f := h - r           // generate all possible fwd & rev candidates from lists
            if isRev(nd, f, r) { // test and append sucesses to temp list
                s = append(s, fmt.Sprintf("%20d %11d %10d  ", f, isr(h), isr(l)))
            }
        }
    }
    sort.Strings(s)
    if len(s) > 0 {
        for _, t := range s { // if there are any, output sorted results
            cn++
            tt := ""
            if t != s[len(s)-1] {
                tt = "\n"
            }
            fmt.Printf("%2d %s%s", cn, t, tt)
        }
    } else {
        fmt.Printf("%48s", "")
    }
}

/* Unsigned variables and functions for nd == 19 */

var (
    usum uint64   // unsigned calculated sum of terms (square candidate)
    urt  uint64   // unsigned root of sum
    acu  []uint64 // unsigned accumulator slice
    ppu  []uint64 // unsigned long coefficient slice that combines with digits of working slice
    sru  []uint64 // unsigned temporary list of squares used for building
)

// Returns Unsigned Integer Square Root.
func isrU(s uint64) uint64 {
    return uint64(math.Sqrt(float64(s)))
}

// Recursively determines whether 'r' is the reverse of 'f'.
func isRevU(nd int, f, r uint64) bool {
    nd--
    if f/uint64(p[nd]) != r%10 {
        return false
    }
    if nd < 1 {
        return true
    }
    return isRevU(nd, f%uint64(p[nd]), r/10)
}

// Recursive function to evaluate the unsigned hi permutations, shortcuts added to avoid
// generating many non-squares, digital root calc added.
func recurseUhi(lst llst, lv int) {
    lv1 := lv - 1
    if lv == dl { // check if on last stage of permutation
        usum = acu[lv1]
        if (0x202021202030213 & (1 << (int(usum) & 63))) != 0 { // test accumulated sum, append to result if square
            urt = uint64(math.Sqrt(float64(usum)))
            if urt*urt == usum {
                sru = append(sru, usum)
            }
        }
    } else {
        for _, n := range lst[lv] { // set up next permutation
            d[lv] = n
            if lv == 0 {
                acu[0] = ppu[0] * uint64(n)
                dac[0] = drar[n] // update accumulated sum and running dr
            } else {
                if n >= 0 {
                    acu[lv] = acu[lv1] + ppu[lv]*uint64(n)
                } else {
                    acu[lv] = acu[lv1] - ppu[lv]*uint64(-n)
                }
                dac[lv] = dac[lv1] + drar[n]
                if dac[lv] > 8 {
                    dac[lv] -= 9
                }
            }
            switch lv { // shortcuts to be performed on designated levels
            case 0: // primary level: set shortcuts for secondary level
                ln = n
                lst[1] = lu[ln]
                lst[2] = l2[n]
            case 1: // secondary level: set shortcuts for tertiary level
                switch ln { // for sums
                case 5, 15:
                    if n < 10 {
                        lst[2] = evh
                    } else {
                        lst[2] = odh
                    }
                case 9:
                    if ((n >> 1) & 1) == 0 {
                        lst[2] = evh
                    } else {
                        lst[2] = odh
                    }
                case 11:
                    if ((n >> 1) & 1) == 1 {
                        lst[2] = evh
                    } else {
                        lst[2] = odh
                    }
                }
            }
            if lv == dl-2 {
                // reduce last round according to dr calc
                if odd {
                    lst[dl-1] = chTen[dac[dl-2]]
                } else {
                    lst[dl-1] = chAH[dac[dl-2]]
                }
            }
            recurseUhi(lst, lv+1) // recursively call next level
        }
    }
}

// Recursive function to evaluate the unsigned lo permutations, shortcuts added to avoid
// generating many non-squares.
func recurseUlo(lst llst, lv int) {
    lv1 := lv - 1
    if lv == dl { // check if on last stage of permutation
        usum = acu[lv1]
        if usum > 0 {
            urt = uint64(math.Sqrt(float64(usum)))
            if urt*urt == usum { // test accumulated sum, append to result if square
                sru = append(sru, usum)
            }
        }
    } else {
        for _, n := range lst[lv] { // set up next permutation
            d[lv] = n
            if lv == 0 {
                acu[0] = ppu[0] * uint64(n)
            } else {
                if n >= 0 {
                    acu[lv] = acu[lv1] + ppu[lv]*uint64(n) // update accumulated sum
                } else {
                    acu[lv] = acu[lv1] - ppu[lv]*uint64(-n)
                }
            }
            switch lv { // shortcuts to be performed on designated levels
            case 0: // primary level: set shortcuts for secondary level
                ln = n
                lst[1] = lu[ln]
                lst[2] = l2[n]
            case 1: // secondary level: set shortcuts for tertiary level
                switch ln { // for difs
                case 1:
                    if (((n + 9) >> 1) & 1) == 0 {
                        lst[2] = evl
                    } else {
                        lst[2] = odl
                    }
                case 5:
                    if n < 0 {
                        lst[2] = evl
                    } else {
                        lst[2] = odl
                    }
                }
            }
            recurseUlo(lst, lv+1) // Recursively call next level
        }
    }
}

// Produces a list of candidate square numbers.
func listEmU(lst, plu, pl2 llst) []uint64 {
    dl = len(lst)
    d = make([]int, dl)
    sru = sru[:0]
    lu = plu
    l2 = pl2
    acu = make([]uint64, dl)
    dac = make([]int, dl) // init support vars
    ppu = make([]uint64, dl)
    for i, j := 0, nd1; i < dl; i, j = i+1, j-1 {
        // build coefficients array
        if len(lst[0]) > 6 {
            ppu[i] = uint64(p[j] + p[i])
        } else {
            ppu[i] = uint64(p[j] - p[i])
        }
    }
    // call appropriate recursive functin  on
    if len(lst[0]) > 8 {
        recurseUhi(lst, 0)
    } else {
        recurseUlo(lst, 0)
    }
    return sru
}

// Reveals whether combining two lists of unsigned squares can produce a Rare number.
func revealU(lo, hi []uint64) {
    var s []string // create temp list of results
    for _, l := range lo {
        for _, h := range hi {
            r := (h - l) >> 1
            f := h - r            // generate all possible fwd & rev candidates from lists
            if isRevU(nd, f, r) { // test and append sucesses to temp list
                s = append(s, fmt.Sprintf("%20d %11d %10d  ", f, isrU(h), isrU(l)))
            }
        }
    }
    sort.Strings(s)
    if len(s) > 0 {
        for _, t := range s { // if there are any, output sorted results
            cn++
            tt := ""
            if t != s[len(s)-1] {
                tt = "\n"
            }
            fmt.Printf("%2d %s%s", cn, t, tt)
        }
    } else {
        fmt.Printf("%48s", "")
    }
}

var (
    bStart time.Time // block start time
    tStart time.Time // total start time
)

// Formats time in form hh:mm:ss.fff (i.e. millisecond precision).
func formatTime(d time.Duration) string {
    f := d.Milliseconds()
    s := f / 1000
    f %= 1000
    m := s / 60
    s %= 60
    h := m / 60
    m %= 60
    return fmt.Sprintf("%02d:%02d:%02d.%03d", h, m, s, f)
}

func main() {
    start := time.Now()
    fmt.Printf("%3s%20s %11s %10s  %3s %11s   %11s\n", "nth", "forward", "rt.sum", "rt.dif", "digs", "block time", "total time")
    p[0] = 1
    for i, j := 0, 1; j < len(p); j++ {
        p[j] = p[i] * 10 // create powers of 10 array
        i = j
    }
    for i := 0; i < len(drar); i++ {
        drar[i] = (i << 1) % 9 // create digital root array
    }
    bStart = time.Now()
    tStart = bStart
    lls := llst{tlo}
    hls := llst{thi}
    for nd <= 18 { // loop through all numbers of digits
        if nd > 2 {
            if odd {
                hls = append(hls, ten)
            } else {
                lls = append(lls, all)
                hls[len(hls)-1] = alh
            }
        } // build permutations list
        tmp1 := listEm(lls, lul, l2l)
        tmp2 := make([]int64, len(tmp1))
        copy(tmp2, tmp1)
        reveal(tmp2, listEm(hls, luh, l2h)) // reveal results
        if !odd && nd > 5 {
            hls[len(hls)-1] = alh // restore last element of hls, so that dr shortcut doesn't mess up next nd
        }
        bTime := formatTime(time.Since(bStart))
        tTime := formatTime(time.Since(tStart))
        fmt.Printf("%2d: %s  %s\n", nd, bTime, tTime)
        bStart = time.Now() // restart block timing
        nd1 = nd
        nd++
        odd = !odd
    }
    // nd == 19
    hls = append(hls, ten)
    tmp3 := listEmU(lls, lul, l2l)
    tmp4 := make([]uint64, len(tmp3))
    copy(tmp4, tmp3)
    revealU(tmp4, listEmU(hls, luh, l2h)) // reveal unsigned results
    fbTime := formatTime(time.Since(bStart))
    ftTime := formatTime(time.Since(tStart))
    fmt.Printf("%2d: %s  %s\n", nd, fbTime, ftTime)
}
