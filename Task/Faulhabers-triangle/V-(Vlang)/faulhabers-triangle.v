import math.fractions
import math.big

fn bernoulli(n int) fractions.Fraction {
    mut a := []fractions.Fraction{len: n+1}
    for m,_ in a {
        a[m] = fractions.fraction(1, i64(m+1))
        for j := m; j >= 1; j-- {
            mut d := a[j-1]
            d = fractions.fraction(i64(j),i64(1)) * (d-a[j])
            a[j-1]=d
        }
    }
    // return the 'first' Bernoulli number
    if n != 1 {
        return a[0]
    }
    a[0] = a[0].negate()
    return a[0]
}

fn binomial(n int, k int) i64 {
    if n <= 0 || k <= 0 || n < k {
        return 1
    }
    mut num, mut den := i64(1), i64(1)
    for i := k + 1; i <= n; i++ {
        num *= i64(i)
    }
    for i := 2; i <= n-k; i++ {
        den *= i64(i)
    }
    return num / den
}

fn faulhaber_triangle(p int) []fractions.Fraction {
    mut coeffs := []fractions.Fraction{len: p+1}
    q := fractions.fraction(1, i64(p)+1)
    mut t := fractions.fraction(1,1)
    mut u := fractions.fraction(1,1)
    mut sign := -1
    for j,_ in coeffs {
        sign *= -1
        mut d := coeffs[p-j]
        t=fractions.fraction(i64(sign),1)
        u = fractions.fraction(binomial(p+1, j),1)
        d=q*t
        d*=u
        d*=bernoulli(j)
        coeffs[p-j]=d
    }
    return coeffs
}

fn main() {
    for i in 0..10 {
        coeffs := faulhaber_triangle(i)
        for coeff in coeffs {
            print("${coeff:5}  ")
        }
        println('')
    }
    println('')
}
