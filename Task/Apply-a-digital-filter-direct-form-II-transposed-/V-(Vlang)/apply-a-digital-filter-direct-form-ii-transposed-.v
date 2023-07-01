struct Filter {
    b []f64
    a []f64
}

fn (f Filter) filter(inp []f64) []f64 {
    mut out := []f64{len: inp.len}
    s := 1.0 / f.a[0]
    for i in 0..inp.len {
        mut tmp := 0.0
        mut b := f.b
        if i+1 < b.len {
            b = b[..i+1]
        }
        for j, bj in b {
            tmp += bj * inp[i-j]
        }
        mut a := f.a[1..]
        if i < a.len {
            a = a[..i]
        }
        for j, aj in a {
            tmp -= aj * out[i-j-1]
        }
        out[i] = tmp * s
    }
    return out
}

//Constants for a Butterworth Filter (order 3, low pass)
const bwf = Filter{
    a: [f64(1.00000000), -2.77555756e-16, 3.33333333e-01, -1.85037171e-17],
    b: [f64(0.16666667), 0.5, 0.5, 0.16666667],
}

const sig = [
    f64(-0.917843918645), 0.141984778794, 1.20536903482, 0.190286794412,
    -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044,
    0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195,
    0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293,
    0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589,
]

fn main() {
    for v in bwf.filter(sig) {
        println("${v:9.6}")
    }
}
