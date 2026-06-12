package main

import (
    "fmt"
    "math"
)

const (
    N    = 32
    NMAX = 40000
)

var (
    u     = [N]int{0: 1, 1: 2} // upper bounds
    l     = [N]int{0: 1, 1: 2} // lower bounds
    out   = [N]int{}
    sum   = [N]int{}
    tail  = [N]int{}
    cache = [NMAX + 1]int{2: 1}
    known = 2
    stack = 0
    undo  = [N * N]save{}
)

type save struct {
    p *int
    v int
}

func replace(x *[N]int, i, n int) {
    undo[stack].p = &x[i]
    undo[stack].v = x[i]
    x[i] = n
    stack++
}

func restore(n int) {
    for stack > n {
        stack--
        *undo[stack].p = undo[stack].v
    }
}

/* lower and upper bounds */
func lower(n int, up *int) int {
    if n <= 2 || (n <= NMAX && cache[n] != 0) {
        if up != nil {
            *up = cache[n]
        }
        return cache[n]
    }
    i, o := -1, 0
    for ; n != 0; n, i = n>>1, i+1 {
        if n&1 != 0 {
            o++
        }
    }
    if up != nil {
        i--
        *up = o + i
    }
    for {
        i++
        o >>= 1
        if o == 0 {
            break
        }
    }
    if up == nil {
        return i
    }
    for o = 2; o*o < n; o++ {
        if n%o != 0 {
            continue
        }
        q := cache[o] + cache[n/o]
        if q < *up {
            *up = q
            if q == i {
                break
            }
        }
    }
    if n > 2 {
        if *up > cache[n-2]+1 {
            *up = cache[n-1] + 1
        }
        if *up > cache[n-2]+1 {
            *up = cache[n-2] + 1
        }
    }
    return i
}

func insert(x, pos int) bool {
    save := stack
    if l[pos] > x || u[pos] < x {
        return false
    }
    if l[pos] == x {
        goto replU
    }
    replace(&l, pos, x)
    for i := pos - 1; u[i]*2 < u[i+1]; i-- {
        t := l[i+1] + 1
        if t*2 > u[i] {
            goto bail
        }
        replace(&l, i, t)
    }
    for i := pos + 1; l[i] <= l[i-1]; i++ {
        t := l[i-1] + 1
        if t > u[i] {
            goto bail
        }
        replace(&l, i, t)
    }
replU:
    if u[pos] == x {
        return true
    }
    replace(&u, pos, x)
    for i := pos - 1; u[i] >= u[i+1]; i-- {
        t := u[i+1] - 1
        if t < l[i] {
            goto bail
        }
        replace(&u, i, t)
    }
    for i := pos + 1; u[i] > u[i-1]*2; i++ {
        t := u[i-1] * 2
        if t < l[i] {
            goto bail
        }
        replace(&u, i, t)
    }
    return true
bail:
    restore(save)
    return false
}

func try(p, q, le int) bool {
    pl := cache[p]
    if pl >= le {
        return false
    }
    ql := cache[q]
    if ql >= le {
        return false
    }
    var pu, qu int
    for pl < le && u[pl] < p {
        pl++
    }
    for pu = pl - 1; pu < le-1 && u[pu+1] >= p; pu++ {

    }
    for ql < le && u[ql] < q {
        ql++
    }
    for qu = ql - 1; qu < le-1 && u[qu+1] >= q; qu++ {

    }
    if p != q && pl <= ql {
        pl = ql + 1
    }
    if pl > pu || ql > qu || ql > pu {
        return false
    }
    if out[le] == 0 {
        pu = le - 1
        pl = pu
    }
    ps := stack
    for ; pu >= pl; pu-- {
        if !insert(p, pu) {
            continue
        }
        out[pu]++
        sum[pu] += le
        if p != q {
            qs := stack
            j := qu
            if j >= pu {
                j = pu - 1
            }
            for ; j >= ql; j-- {
                if !insert(q, j) {
                    continue
                }
                out[j]++
                sum[j] += le
                tail[le] = q
                if seqRecur(le - 1) {
                    return true
                }
                restore(qs)
                out[j]--
                sum[j] -= le
            }
        } else {
            out[pu]++
            sum[pu] += le
            tail[le] = p
            if seqRecur(le - 1) {
                return true
            }
            out[pu]--
            sum[pu] -= le
        }
        out[pu]--
        sum[pu] -= le
        restore(ps)
    }
    return false
}

func seqRecur(le int) bool {
    n := l[le]
    if le < 2 {
        return true
    }
    limit := n - 1
    if out[le] == 1 {
        limit = n - tail[sum[le]]
    }
    if limit > u[le-1] {
        limit = u[le-1]
    }
    // Try to break n into p + q, and see if we can insert p, q into
    // list while satisfying bounds.
    p := limit
    for q := n - p; q <= p; q, p = q+1, p-1 {
        if try(p, q, le) {
            return true
        }
    }
    return false
}

func seq(n, le int, buf []int) int {
    if le == 0 {
        le = seqLen(n)
    }
    stack = 0
    l[le], u[le] = n, n
    for i := 0; i <= le; i++ {
        out[i], sum[i] = 0, 0
    }
    for i := 2; i < le; i++ {
        l[i] = l[i-1] + 1
        u[i] = u[i-1] * 2
    }
    for i := le - 1; i > 2; i-- {
        if l[i]*2 < l[i+1] {
            l[i] = (1 + l[i+1]) / 2
        }
        if u[i] >= u[i+1] {
            u[i] = u[i+1] - 1
        }
    }
    if !seqRecur(le) {
        return 0
    }
    if buf != nil {
        for i := 0; i <= le; i++ {
            buf[i] = u[i]
        }
    }
    return le
}

func seqLen(n int) int {
    if n <= known {
        return cache[n]
    }
    // Need all lower n to compute sequence.
    for known+1 < n {
        seqLen(known + 1)
    }
    var ub int
    lb := lower(n, &ub)
    for lb < ub && seq(n, lb, nil) == 0 {
        lb++
    }
    known = n
    if n&1023 == 0 {
        fmt.Printf("Cached %d\n", known)
    }
    cache[n] = lb
    return lb
}

func binLen(n int) int {
    r, o := -1, -1
    for ; n != 0; n, r = n>>1, r+1 {
        if n&1 != 0 {
            o++
        }
    }
    return r + o
}

type(
    vector = []float64
    matrix []vector
)

func (m1 matrix) mul(m2 matrix) matrix {
    rows1, cols1 := len(m1), len(m1[0])
    rows2, cols2 := len(m2), len(m2[0])
    if cols1 != rows2 {
        panic("Matrices cannot be multiplied.")
    }
    result := make(matrix, rows1)
    for i := 0; i < rows1; i++ {
        result[i] = make(vector, cols2)
        for j := 0; j < cols2; j++ {
            for k := 0; k < rows2; k++ {
                result[i][j] += m1[i][k] * m2[k][j]
            }
        }
    }
    return result
}

func (m matrix) pow(n int, printout bool) matrix {
    e := make([]int, N)
    var v [N]matrix
    le := seq(n, 0, e)
    if printout {
        fmt.Println("Addition chain:")
        for i := 0; i <= le; i++ {
            c := ' '
            if i == le {
                c = '\n'
            }
            fmt.Printf("%d%c", e[i], c)
        }
    }
    v[0] = m
    v[1] = m.mul(m)
    for i := 2; i <= le; i++ {
        for j := i - 1; j != 0; j-- {
            for k := j; k >= 0; k-- {
                if e[k]+e[j] < e[i] {
                    break
                }
                if e[k]+e[j] > e[i] {
                    continue
                }
                v[i] = v[j].mul(v[k])
                j = 1
                break
            }
        }
    }
    return v[le]
}

func (m matrix) print() {
    for _, v := range m {
        fmt.Printf("% f\n", v)
    }
    fmt.Println()
}

func main() {
    m := 27182
    n := 31415
    fmt.Println("Precompute chain lengths:")
    seqLen(n)
    rh := math.Sqrt(0.5)
    mx := matrix{
        {rh, 0, rh, 0, 0, 0},
        {0, rh, 0, rh, 0, 0},
        {0, rh, 0, -rh, 0, 0},
        {-rh, 0, rh, 0, 0, 0},
        {0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 1, 0},
    }
    fmt.Println("\nThe first 100 terms of A003313 are:")
    for i := 1; i <= 100; i++ {
        fmt.Printf("%d ", seqLen(i))
        if i%10 == 0 {
            fmt.Println()
        }
    }
    exs := [2]int{m, n}
    mxs := [2]matrix{}
    for i, ex := range exs {
        fmt.Println("\nExponent:", ex)
        mxs[i] = mx.pow(ex, true)
        fmt.Printf("A ^ %d:-\n\n", ex)
        mxs[i].print()
        fmt.Println("Number of A/C multiplies:", seqLen(ex))
        fmt.Println("  c.f. Binary multiplies:", binLen(ex))
    }
    fmt.Printf("\nExponent: %d x %d = %d\n", m, n, m*n)
    fmt.Printf("A ^ %d = (A ^ %d) ^ %d:-\n\n", m*n, m, n)
    mx2 := mxs[0].pow(n, false)
    mx2.print()
}
