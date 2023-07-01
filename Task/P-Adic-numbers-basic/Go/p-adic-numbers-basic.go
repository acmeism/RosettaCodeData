package main

import "fmt"

// constants
const EMX = 64      // exponent maximum (if indexing starts at -EMX)
const DMX = 100000  // approximation loop maximum
const AMX = 1048576 // argument maximum
const PMAX = 32749  // prime maximum

// global variables
var p1 = 0
var p = 7  // default prime
var k = 11 // precision

func abs(a int) int {
    if a >= 0 {
        return a
    }
    return -a
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

type Ratio struct {
    a, b int
}

type Padic struct {
    v int
    d [2 * EMX]int // add EMX to index to be consistent wih FB
}

// (re)initialize receiver from Ratio, set 'sw' to print
func (pa *Padic) r2pa(q Ratio, sw int) int {
    a := q.a
    b := q.b
    if b == 0 {
        return 1
    }
    if b < 0 {
        b = -b
        a = -a
    }
    if abs(a) > AMX || b > AMX {
        return -1
    }
    if p < 2 || k < 1 {
        return 1
    }
    p = min(p, PMAX)  // maximum short prime
    k = min(k, EMX-1) // maxumum array length
    if sw != 0 {
        fmt.Printf("%d/%d + ", a, b)   // numerator, denominator
        fmt.Printf("0(%d^%d)\n", p, k) // prime, precision
    }

    // (re)initialize
    pa.v = 0
    p1 = p - 1
    pa.d = [2 * EMX]int{}
    if a == 0 {
        return 0
    }
    i := 0

    // find -exponent of p in b
    for b%p == 0 {
        b = b / p
        i--
    }
    s := 0
    r := b % p

    // modular inverse for small p
    b1 := 1
    for b1 <= p1 {
        s += r
        if s > p1 {
            s -= p
        }
        if s == 1 {
            break
        }
        b1++
    }
    if b1 == p {
        fmt.Println("r2pa: impossible inverse mod")
        return -1
    }
    pa.v = EMX
    for {
        // find exponent of P in a
        for a%p == 0 {
            a = a / p
            i++
        }

        // valuation
        if pa.v == EMX {
            pa.v = i
        }

        // upper bound
        if i >= EMX {
            break
        }

        // check precision
        if (i - pa.v) > k {
            break
        }

        // next digit
        pa.d[i+EMX] = a * b1 % p
        if pa.d[i+EMX] < 0 {
            pa.d[i+EMX] += p
        }

        // remainder - digit * divisor
        a -= pa.d[i+EMX] * b
        if a == 0 {
            break
        }
    }
    return 0
}

// Horner's rule
func (pa *Padic) dsum() int {
    t := min(pa.v, 0)
    s := 0
    for i := k - 1 + t; i >= t; i-- {
        r := s
        s *= p
        if r != 0 && (s/r-p != 0) {
            // overflow
            s = -1
            break
        }
        s += pa.d[i+EMX]
    }
    return s
}

// add b to receiver
func (pa *Padic) add(b Padic) *Padic {
    c := 0
    r := Padic{}
    r.v = min(pa.v, b.v)
    for i := r.v; i <= k+r.v; i++ {
        c += pa.d[i+EMX] + b.d[i+EMX]
        if c > p1 {
            r.d[i+EMX] = c - p
            c = 1
        } else {
            r.d[i+EMX] = c
            c = 0
        }
    }
    return &r
}

// complement of receiver
func (pa *Padic) cmpt() *Padic {
    c := 1
    r := Padic{}
    r.v = pa.v
    for i := pa.v; i <= k+pa.v; i++ {
        c += p1 - pa.d[i+EMX]
        if c > p1 {
            r.d[i+EMX] = c - p
            c = 1
        } else {
            r.d[i+EMX] = c
            c = 0
        }
    }
    return &r
}

// rational reconstruction
func (pa *Padic) crat() {
    fl := false
    s := pa
    j := 0
    i := 1

    // denominator count
    for i <= DMX {
        // check for integer
        j = k - 1 + pa.v
        for j >= pa.v {
            if s.d[j+EMX] != 0 {
                break
            }
            j--
        }
        fl = ((j - pa.v) * 2) < k
        if fl {
            fl = false
            break
        }

        // check negative integer
        j = k - 1 + pa.v
        for j >= pa.v {
            if p1-s.d[j+EMX] != 0 {
                break
            }
            j--
        }
        fl = ((j - pa.v) * 2) < k
        if fl {
            break
        }

        // repeatedly add self to s
        s = s.add(*pa)
        i++
    }
    if fl {
        s = s.cmpt()
    }

    // numerator: weighted digit sum
    x := s.dsum()
    y := i
    if x < 0 || y > DMX {
        fmt.Println(x, y)
        fmt.Println("crat: fail")
    } else {
        // negative powers
        i = pa.v
        for i <= -1 {
            y *= p
            i++
        }

        // negative rational
        if fl {
            x = -x
        }
        fmt.Print(x)
        if y > 1 {
            fmt.Printf("/%d", y)
        }
        fmt.Println()
    }
}

// print expansion
func (pa *Padic) printf(sw int) {
    t := min(pa.v, 0)
    for i := k - 1 + t; i >= t; i-- {
        fmt.Print(pa.d[i+EMX])
        if i == 0 && pa.v < 0 {
            fmt.Print(".")
        }
        fmt.Print(" ")
    }
    fmt.Println()
    // rational approximation
    if sw != 0 {
        pa.crat()
    }
}

func main() {
    data := [][]int{
        /* rational reconstruction depends on the precision
           until the dsum-loop overflows */
        {2, 1, 2, 4, 1, 1},
        {4, 1, 2, 4, 3, 1},
        {4, 1, 2, 5, 3, 1},
        {4, 9, 5, 4, 8, 9},
        {26, 25, 5, 4, -109, 125},
        {49, 2, 7, 6, -4851, 2},
        {-9, 5, 3, 8, 27, 7},
        {5, 19, 2, 12, -101, 384},
        /* two decadic pairs */
        {2, 7, 10, 7, -1, 7},
        {34, 21, 10, 9, -39034, 791},
        /* familiar digits */
        {11, 4, 2, 43, 679001, 207},
        {-8, 9, 23, 9, 302113, 92},
        {-22, 7, 3, 23, 46071, 379},
        {-22, 7, 32749, 3, 46071, 379},
        {35, 61, 5, 20, 9400, 109},
        {-101, 109, 61, 7, 583376, 6649},
        {-25, 26, 7, 13, 5571, 137},
        {1, 4, 7, 11, 9263, 2837},
        {122, 407, 7, 11, -517, 1477},
        /* more subtle */
        {5, 8, 7, 11, 353, 30809},
    }

    sw := 0
    a := Padic{}
    b := Padic{}

    for _, d := range data {
        q := Ratio{d[0], d[1]}
        p = d[2]
        k = d[3]
        sw = a.r2pa(q, 1)
        if sw == 1 {
            break
        }
        a.printf(0)
        q.a = d[4]
        q.b = d[5]
        sw = sw | b.r2pa(q, 1)
        if sw == 1 {
            break
        }
        if sw == 0 {
            b.printf(0)
            c := a.add(b)
            fmt.Println("+ =")
            c.printf(1)
        }
        fmt.Println()
    }
}
