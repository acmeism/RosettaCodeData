package main

import (
    "fmt"
    "log"
    "math"
    "strings"
)

const (
    maxdp           = 81
    binary          = "01"
    ternary         = "012"
    balancedTernary = "-0+"
    decimal         = "0123456789"
    hexadecimal     = "0123456789ABCDEF"
    septemVigesimal = "0123456789ABCDEFGHIJKLMNOPQ"
    balancedBase27  = "ZYXWVUTSRQPON0ABCDEFGHIJKLM"
    base37          = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
)

/* helper functions */

func changeByte(s string, idx int, c byte) string {
    bytes := []byte(s)
    bytes[idx] = c
    return string(bytes)
}

func removeByte(s string, idx int) string {
    le := len(s)
    bytes := []byte(s)
    copy(bytes[idx:], bytes[idx+1:])
    return string(bytes[0 : le-1])
}

func insertByte(s string, idx int, c byte) string {
    le := len(s)
    t := make([]byte, le+1)
    copy(t, s)
    copy(t[idx+1:], t[idx:])
    t[idx] = c
    return string(t)
}

func prependByte(s string, c byte) string {
    le := len(s)
    bytes := make([]byte, le+1)
    copy(bytes[1:], s)
    bytes[0] = c
    return string(bytes)
}

func abs(i int) int {
    if i < 0 {
        return -i
    }
    return i
}

// converts Phix indices to Go
func gIndex(pIndex, le int) int {
    if pIndex < 0 {
        return pIndex + le
    }
    return pIndex - 1
}

func getCarry(digit, base int) int {
    if digit > base {
        return 1
    } else if digit < 1 {
        return -1
    }
    return 0
}

// convert string 'b' to a decimal floating point number
func b2dec(b, alphabet string) float64 {
    res := 0.0
    base := len(alphabet)
    zdx := strings.IndexByte(alphabet, '0') + 1
    signed := zdx == 1 && b[0] == '-'
    if signed {
        b = b[1:]
    }
    le := len(b)
    ndp := strings.IndexByte(b, '.') + 1
    if ndp != 0 {
        b = removeByte(b, ndp-1) // remove decimal point
        ndp = le - ndp
    }
    for i := 1; i <= len(b); i++ {
        idx := strings.IndexByte(alphabet, b[i-1]) + 1
        res = float64(base)*res + float64(idx) - float64(zdx)
    }
    if ndp != 0 {
        res /= math.Pow(float64(base), float64(ndp))
    }
    if signed {
        res = -res
    }
    return res
}

// string 'b' can be balanced or unbalanced
func negate(b, alphabet string) string {
    if alphabet[0] == '0' {
        if b != "0" {
            if b[0] == '-' {
                b = b[1:]
            } else {
                b = prependByte(b, '-')
            }
        }
    } else {
        for i := 1; i <= len(b); i++ {
            if b[i-1] != '.' {
                idx := strings.IndexByte(alphabet, b[i-1]) + 1
                gi := gIndex(-idx, len(alphabet))
                b = changeByte(b, i-1, alphabet[gi])
            }
        }
    }
    return b
}

func bTrim(b string) string {
    // trim  trailing ".000"
    idx := strings.IndexByte(b, '.') + 1
    if idx != 0 {
        b = strings.TrimRight(strings.TrimRight(b, "0"), ".")
    }
    // trim leading zeros but not "0.nnn"
    for len(b) > 1 && b[0] == '0' && b[1] != '.' {
        b = b[1:]
    }
    return b
}

// for balanced number systems only
func bCarry(digit, base, idx int, n, alphabet string) (int, string) {
    carry := getCarry(digit, base)
    if carry != 0 {
        for i := idx; i >= 1; i-- {
            if n[i-1] != '.' {
                k := strings.IndexByte(alphabet, n[i-1]) + 1
                if k < base {
                    n = changeByte(n, i-1, alphabet[k])
                    break
                }
                n = changeByte(n, i-1, alphabet[0])
            }
        }
        digit -= base * carry
    }
    return digit, n
}

// convert a string from alphabet to alphabet2
func b2b(n, alphabet, alphabet2 string) string {
    res, m := "0", ""
    if n != "0" {
        base := len(alphabet)
        base2 := len(alphabet2)
        zdx := strings.IndexByte(alphabet, '0') + 1
        zdx2 := strings.IndexByte(alphabet2, '0') + 1
        var carry, q, r, digit int
        idx := strings.IndexByte(alphabet, n[0]) + 1
        negative := (zdx == 1 && n[0] == '-') || (zdx != 1 && idx < zdx)
        if negative {
            n = negate(n, alphabet)
        }
        ndp := strings.IndexByte(n, '.') + 1
        if ndp != 0 {
            n, m = n[0:ndp-1], n[ndp:]
        }
        res = ""
        for len(n) > 0 {
            q = 0
            for i := 1; i <= len(n); i++ {
                digit = strings.IndexByte(alphabet, n[i-1]) + 1 - zdx
                q = q*base + digit
                r = abs(q) % base2
                digit = abs(q)/base2 + zdx
                if q < 0 {
                    digit--
                }
                if zdx != 1 {
                    digit, n = bCarry(digit, base, i-1, n, alphabet)
                }
                n = changeByte(n, i-1, alphabet[digit-1])
                q = r
            }
            r += zdx2
            if zdx2 != 1 {
                r += carry
                carry = getCarry(r, base2)
                r -= base2 * carry
            }
            res = prependByte(res, alphabet2[r-1])
            n = strings.TrimLeft(n, "0")
        }
        if carry != 0 {
            res = prependByte(res, alphabet2[carry+zdx2-1])
        }
        if len(m) > 0 {
            res += "."
            ndp = 0
            if zdx != 1 {
                lm := len(m)
                alphaNew := base37[0:len(alphabet)]
                m = b2b(m, alphabet, alphaNew)
                m = strings.Repeat("0", lm-len(m)) + m
                alphabet = alphaNew
                zdx = 1
            }
            for len(m) > 0 && ndp < maxdp {
                q = 0
                for i := len(m); i >= 1; i-- {
                    digit = strings.IndexByte(alphabet, m[i-1]) + 1 - zdx
                    q += digit * base2
                    r = abs(q)%base + zdx
                    q /= base
                    if q < 0 {
                        q--
                    }
                    m = changeByte(m, i-1, alphabet[r-1])
                }
                digit = q + zdx2
                if zdx2 != 1 {
                    digit, res = bCarry(digit, base2, len(res), res, alphabet2)
                }
                res += string(alphabet2[digit-1])
                m = strings.TrimRight(m, "0")
                ndp++
            }
        }
        res = bTrim(res)
        if negative {
            res = negate(res, alphabet2)
        }
    }
    return res
}

// convert 'd' to a string in the specified base
func float2b(d float64, alphabet string) string {
    base := len(alphabet)
    zdx := strings.Index(alphabet, "0") + 1
    carry := 0
    neg := d < 0
    if neg {
        d = -d
    }
    res := ""
    whole := int(d)
    d -= float64(whole)
    for {
        ch := whole%base + zdx
        if zdx != 1 {
            ch += carry
            carry = getCarry(ch, base)
            ch -= base * carry
        }
        res = prependByte(res, alphabet[ch-1])
        whole /= base
        if whole == 0 {
            break
        }
    }
    if carry != 0 {
        res = prependByte(res, alphabet[carry+zdx-1])
        carry = 0
    }
    if d != 0 {
        res += "."
        ndp := 0
        for d != 0 && ndp < maxdp {
            d *= float64(base)
            digit := int(d) + zdx
            d -= float64(digit)
            if zdx != 1 {
                digit, res = bCarry(digit, base, len(res), res, alphabet)
            }
            res += string(alphabet[digit-1])
            ndp++
        }
    }
    if neg {
        res = negate(res, alphabet)
    }
    return res
}

func bAdd(a, b, alphabet string) string {
    base := len(alphabet)
    zdx := strings.IndexByte(alphabet, '0') + 1
    var carry, da, db, digit int
    if zdx == 1 {
        if a[0] == '-' {
            return bSub(b, negate(a, alphabet), alphabet)
        }
        if b[0] == '-' {
            return bSub(a, negate(b, alphabet), alphabet)
        }
    }
    adt := strings.IndexByte(a, '.') + 1
    bdt := strings.IndexByte(b, '.') + 1
    if adt != 0 || bdt != 0 {
        if adt != 0 {
            adt = len(a) - adt + 1
            gi := gIndex(-adt, len(a))
            a = removeByte(a, gi)
        }
        if bdt != 0 {
            bdt = len(b) - bdt + 1
            gi := gIndex(-bdt, len(b))
            b = removeByte(b, gi)
        }
        if bdt > adt {
            a += strings.Repeat("0", bdt-adt)
            adt = bdt
        } else if adt > bdt {
            b += strings.Repeat("0", adt-bdt)
        }
    }
    if len(a) < len(b) {
        a, b = b, a
    }
    for i := -1; i >= -len(a); i-- {
        if i < -len(a) {
            da = 0
        } else {
            da = strings.IndexByte(alphabet, a[len(a)+i]) + 1 - zdx
        }
        if i < -len(b) {
            db = 0
        } else {
            db = strings.IndexByte(alphabet, b[len(b)+i]) + 1 - zdx
        }
        digit = da + db + carry + zdx
        carry = getCarry(digit, base)
        a = changeByte(a, i+len(a), alphabet[digit-carry*base-1])
        if i < -len(b) && carry == 0 {
            break
        }
    }
    if carry != 0 {
        a = prependByte(a, alphabet[carry+zdx-1])
    }
    if adt != 0 {
        gi := gIndex(-adt+1, len(a))
        a = insertByte(a, gi, '.')
    }
    a = bTrim(a)
    return a
}

func aSmaller(a, b, alphabet string) bool {
    if len(a) != len(b) {
        log.Fatal("strings should be equal in length")
    }
    for i := 1; i <= len(a); i++ {
        da := strings.IndexByte(alphabet, a[i-1]) + 1
        db := strings.IndexByte(alphabet, b[i-1]) + 1
        if da != db {
            return da < db
        }
    }
    return false
}

func bSub(a, b, alphabet string) string {
    base := len(alphabet)
    zdx := strings.IndexByte(alphabet, '0') + 1
    var carry, da, db, digit int
    if zdx == 1 {
        if a[0] == '-' {
            return negate(bAdd(negate(a, alphabet), b, alphabet), alphabet)
        }
        if b[0] == '-' {
            return bAdd(a, negate(b, alphabet), alphabet)
        }
    }
    adt := strings.Index(a, ".") + 1
    bdt := strings.Index(b, ".") + 1
    if adt != 0 || bdt != 0 {
        if adt != 0 {
            adt = len(a) - adt + 1
            gi := gIndex(-adt, len(a))
            a = removeByte(a, gi)
        }
        if bdt != 0 {
            bdt = len(b) - bdt + 1
            gi := gIndex(-bdt, len(b))
            b = removeByte(b, gi)
        }
        if bdt > adt {
            a += strings.Repeat("0", bdt-adt)
            adt = bdt
        } else if adt > bdt {
            b += strings.Repeat("0", adt-bdt)
        }
    }
    bNegate := false
    if len(a) < len(b) || (len(a) == len(b) && aSmaller(a, b, alphabet)) {
        bNegate = true
        a, b = b, a
    }
    for i := -1; i >= -len(a); i-- {
        if i < -len(a) {
            da = 0
        } else {
            da = strings.IndexByte(alphabet, a[len(a)+i]) + 1 - zdx
        }
        if i < -len(b) {
            db = 0
        } else {
            db = strings.IndexByte(alphabet, b[len(b)+i]) + 1 - zdx
        }
        digit = da - db - carry + zdx
        carry = 0
        if digit <= 0 {
            carry = 1
        }
        a = changeByte(a, i+len(a), alphabet[digit+carry*base-1])
        if i < -len(b) && carry == 0 {
            break
        }
    }
    if carry != 0 {
        log.Fatal("carry should be zero")
    }
    if adt != 0 {
        gi := gIndex(-adt+1, len(a))
        a = insertByte(a, gi, '.')
    }
    a = bTrim(a)
    if bNegate {
        a = negate(a, alphabet)
    }
    return a
}

func bMul(a, b, alphabet string) string {
    zdx := strings.IndexByte(alphabet, '0') + 1
    dpa := strings.IndexByte(a, '.') + 1
    dpb := strings.IndexByte(b, '.') + 1
    ndp := 0
    if dpa != 0 {
        ndp += len(a) - dpa
        a = removeByte(a, dpa-1)
    }
    if dpb != 0 {
        ndp += len(b) - dpb
        b = removeByte(b, dpb-1)
    }
    pos, res := a, "0"
    if zdx != 1 {
        // balanced number systems
        neg := negate(pos, alphabet)
        for i := len(b); i >= 1; i-- {
            m := strings.IndexByte(alphabet, b[i-1]) + 1 - zdx
            for m != 0 {
                temp, temp2 := pos, -1
                if m < 0 {
                    temp = neg
                    temp2 = 1
                }
                res = bAdd(res, temp, alphabet)
                m += temp2
            }
            pos += "0"
            neg += "0"
        }
    } else {
        // non-balanced number systems
        negative := false
        if a[0] == '-' {
            a = a[1:]
            negative = true
        }
        if b[0] == '-' {
            b = b[1:]
            negative = !negative
        }
        for i := len(b); i >= 1; i-- {
            m := strings.IndexByte(alphabet, b[i-1]) + 1 - zdx
            for m > 0 {
                res = bAdd(res, pos, alphabet)
                m--
            }
            pos += "0"
        }
        if negative {
            res = negate(res, alphabet)
        }
    }
    if ndp != 0 {
        gi := gIndex(-ndp, len(res))
        res = insertByte(res, gi, '.')
    }
    res = bTrim(res)
    return res
}

func multTable() {
    fmt.Println("multiplication table")
    fmt.Println("====================")
    fmt.Printf("* |")
    for j := 1; j <= 12; j++ {
        fj := float64(j)
        fmt.Printf(" #%s %3s |", float2b(fj, hexadecimal), float2b(fj, balancedTernary))
    }
    for i := 1; i <= 27; i++ {
        fi := float64(i)
        a := float2b(fi, balancedTernary)
        fmt.Printf("\n%-2s|", float2b(fi, septemVigesimal))
        for j := 1; j <= 12; j++ {
            if j > i {
                fmt.Printf("        |")
            } else {
                fj := float64(j)
                b := float2b(fj, balancedTernary)
                m := bMul(a, b, balancedTernary)
                fmt.Printf(" %6s |", m)
            }
        }
    }
    fmt.Println()
}

func test(name, alphabet string) {
    a := b2b("+-0++0+.+-0++0+", balancedTernary, alphabet)
    b := b2b("-436.436", decimal, alphabet)
    c := b2b("+-++-.+-++-", balancedTernary, alphabet)
    d := bSub(b, c, alphabet)
    r := bMul(a, d, alphabet)
    fmt.Printf("%s\n%s\n", name, strings.Repeat("=", len(name)))
    fmt.Printf("      a = %.16g  %s\n", b2dec(a, alphabet), a)
    fmt.Printf("      b = %.16g  %s\n", b2dec(b, alphabet), b)
    fmt.Printf("      c = %.16g  %s\n", b2dec(c, alphabet), c)
    fmt.Printf("a*(b-c) = %.16g  %s\n\n", b2dec(r, alphabet), r)
}

func main() {
    test("balanced ternary", balancedTernary)
    test("balanced base 27", balancedBase27)
    test("decimal", decimal)
    test("binary", binary)
    test("ternary", ternary)
    test("hexadecimal", hexadecimal)
    test("septemvigesimal", septemVigesimal)
    multTable()
}
