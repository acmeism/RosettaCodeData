import math.fractions
import math
import strconv

fn calkin_wilf(n int) []fractions.Fraction {
    mut cw := []fractions.Fraction{len: n+1}
    cw[0] = fractions.fraction(1, 1)
    one := fractions.fraction(1, 1)
    two := fractions.fraction(2, 1)
    for i in 1..n {
        mut t := cw[i-1]
        mut f := t.f64()
        f = math.floor(f)
        t = fractions.approximate(f)
        t*=two
        t-= cw[i-1]
        t+=one
        t=t.reciprocal()
        cw[i] = t
    }
    return cw
}

fn to_continued(r fractions.Fraction) []int {
	idx := r.str().index('/') or {0}
    mut a := r.str()[..idx].i64()
    mut b := r.str()[idx+1..].i64()
    mut res := []int{}
    for {
        res << int(a/b)
        t := a % b
        a, b = b, t
        if a == 1 {
            break
        }
    }
    le := res.len
    if le%2 == 0 { // ensure always odd
        res[le-1]--
        res << 1
    }
    return res
}

fn get_term_number(cf []int) ?int {
    mut b := ""
    mut d := "1"
    for n in cf {
        b = d.repeat(n)+b
        if d == "1" {
            d = "0"
        } else {
            d = "1"
        }
    }
    i := strconv.parse_int(b, 2, 64)?
    return int(i)
}

fn commatize(n int) string {
    mut s := "$n"
    if n < 0 {
        s = s[1..]
    }
    le := s.len
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0..i] + "," + s[i..]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

fn main() {
    cw := calkin_wilf(20)
    println("The first 20 terms of the Calkin-Wilf sequnence are:")
    for i := 1; i <= 20; i++ {
        println("${i:2}: ${cw[i-1]}")
    }
    println('')
    r := fractions.fraction(83116, 51639)
    cf := to_continued(r)
    tn := get_term_number(cf) or {0}
    println("$r is the ${commatize(tn)}th term of the sequence.")
}
