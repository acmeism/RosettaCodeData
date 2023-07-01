package main

import (
    "bytes"
    "fmt"
    "strconv"
    "strings"
)

const digits = "0123456789"

func deBruijn(k, n int) string {
    alphabet := digits[0:k]
    a := make([]byte, k*n)
    var seq []byte
    var db func(int, int) // recursive closure
    db = func(t, p int) {
        if t > n {
            if n%p == 0 {
                seq = append(seq, a[1:p+1]...)
            }
        } else {
            a[t] = a[t-p]
            db(t+1, p)
            for j := int(a[t-p] + 1); j < k; j++ {
                a[t] = byte(j)
                db(t+1, t)
            }
        }
    }
    db(1, 1)
    var buf bytes.Buffer
    for _, i := range seq {
        buf.WriteByte(alphabet[i])
    }
    b := buf.String()
    return b + b[0:n-1] // as cyclic append first (n-1) digits
}

func allDigits(s string) bool {
    for _, b := range s {
        if b < '0' || b > '9' {
            return false
        }
    }
    return true
}

func validate(db string) {
    le := len(db)
    found := make([]int, 10000)
    var errs []string
    // Check all strings of 4 consecutive digits within 'db'
    // to see if all 10,000 combinations occur without duplication.
    for i := 0; i < le-3; i++ {
        s := db[i : i+4]
        if allDigits(s) {
            n, _ := strconv.Atoi(s)
            found[n]++
        }
    }
    for i := 0; i < 10000; i++ {
        if found[i] == 0 {
            errs = append(errs, fmt.Sprintf("    PIN number %04d missing", i))
        } else if found[i] > 1 {
            errs = append(errs, fmt.Sprintf("    PIN number %04d occurs %d times", i, found[i]))
        }
    }
    lerr := len(errs)
    if lerr == 0 {
        fmt.Println("  No errors found")
    } else {
        pl := "s"
        if lerr == 1 {
            pl = ""
        }
        fmt.Printf("  %d error%s found:\n", lerr, pl)
        fmt.Println(strings.Join(errs, "\n"))
    }
}

func reverse(s string) string {
    bytes := []byte(s)
    for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
        bytes[i], bytes[j] = bytes[j], bytes[i]
    }
    return string(bytes)
}

func main() {
    db := deBruijn(10, 4)
    le := len(db)
    fmt.Println("The length of the de Bruijn sequence is", le)
    fmt.Println("\nThe first 130 digits of the de Bruijn sequence are:")
    fmt.Println(db[0:130])
    fmt.Println("\nThe last 130 digits of the de Bruijn sequence are:")
    fmt.Println(db[le-130:])
    fmt.Println("\nValidating the de Bruijn sequence:")
    validate(db)

    fmt.Println("\nValidating the reversed de Bruijn sequence:")
    dbr := reverse(db)
    validate(dbr)

    bytes := []byte(db)
    bytes[4443] = '.'
    db = string(bytes)
    fmt.Println("\nValidating the overlaid de Bruijn sequence:")
    validate(db)
}
