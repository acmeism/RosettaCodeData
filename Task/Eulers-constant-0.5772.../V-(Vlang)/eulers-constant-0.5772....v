import math
const eps = 1e-6
fn main() {
    //.5772
    println("From the definition, err. 3e-10")
    mut n := 400
    mut h := 1.0
    for k in 2..n+1 {
        h += 1.0/f64(k)
    }
    //faster convergence: Negoi, 1997
    mut a := math.log(f64(n) + 0.5 + 1.0/f64(24*n))

    println("Hn    ${h:0.16f}")
    println("gamma ${h-a:0.16f}\nk = $n\n")

    println("Sweeney, 1963, err. idem")
    n = 21
    mut s := [0.0, f64(n)]
    mut r := f64(n)
    mut k := 1
    for {
        k++
        r *= f64(n) / f64(k)
        s[k & 1] += r/f64(k)
        if r <= eps {
            break
        }
    }
    println("gamma ${s[1] - s[0] - math.log(n):0.16f}\nk = $k\n")

    println("Bailey, 1988")
    n = 5
    a = 1.0
    h = 1.0
    mut n2 := math.pow(f64(2),f64(n))
    r = 1
    k = 1
    for {
        k++
        r *= n2 / f64(k)
        h += 1/f64(k)
        b := a
        a += r * h
        if math.abs(b-a) <= eps {
            break
        }
    }
    a *= n2 / math.exp(n2)
    println("gamma ${a - n * math.log(2):.16f}\nk = $k\n")

    println("Brent-McMillan, 1980")
    n = 13
    a = -math.log(n)
    mut b := 1.0
    mut u := a
    mut v := b
    n2 = n * n
    mut k2 := 0
    k = 0
    for {
        k2 += 2*k + 1
        k++
        a *= n2 / f64(k)
        b *= n2 / f64(k2)
        a = (a + b)/f64(k)
        u += a
        v += b
        if math.abs(a) <= eps {
            break
        }
    }
    println("gamma ${u/v:0.16f}\nk = $k\n")

    println("How Euler did it in 1735")
    // Bernoulli numbers with even indices
    b2 := [1.0, 1.0/6, -1.0/30, 1.0/42, -1.0/30, 5.0/66, -691.0/2730, 7.0/6, -3617.0/510, 43867.0/798]
    m := 7
    n = 10
    // n'th harmonic number
    h = 1.0
    for kz in 2..n+1 {
        h += 1.0/f64(kz)
    }
    println("Hn    ${h:0.16f}")
    h -= math.log(n)
    println("  -ln ${h:0.16f}")
    // expansion C = -digamma(1)
    a = -1.0 / (2.0*f64(n))
    n2 = f64(n * n)
    r = 1
    for kq in 1..m+1 {
        r *= n2
        a += b2[kq] / (2.0*f64(kq)*r)
    }
    println("err  ${a:0.16f}\ngamma ${h+a:0.16f}\nk = ${n+m}")
    println("\nC = 0.57721566490153286...")
}
