fn main() {
    mut a := [0, 1, 1] // ignore 0 element. work 1 based.
    mut x := 1  // last number in list
    mut n := 2  // index of last number in list = a.len-1
    mut mallow := 0
    for p in 1..20 {
        mut max := 0.0
        for next_pot := n*2; n < next_pot; {
            n = a.len  // advance n
            x = a[x]+a[n-x]
            a << x
            f := f64(x)/f64(n)
            if f > max {
                max = f
            }
            if f >= .55 {
                mallow = n
            }
        }
        println("max between 2^$p and 2^${p+1} was ${max:.6}")
    }
    println("winning number $mallow")
}
