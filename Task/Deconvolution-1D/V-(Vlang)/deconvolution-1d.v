fn main() {
    h := [f64(-8), -9, -3, -1, -6, 7]
    f := [f64(-3), -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1]
    g := [f64(24), 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
        96, 31, 55, 36, 29, -43, -7]
    println(h)
    println(deconv(g, f))
    println(f)
    println(deconv(g, h))
}

fn deconv(g []f64, f []f64) []f64 {
    mut h := []f64{len: g.len-f.len+1}
    for n in 0..h.len {
        h[n] = g[n]
        mut lower := 0
        if n >= f.len {
            lower = n - f.len + 1
        }
        for i in lower..n {
            h[n] -= h[i] * f[n-i]
        }
        h[n] /= f[0]
    }
    return h
}
