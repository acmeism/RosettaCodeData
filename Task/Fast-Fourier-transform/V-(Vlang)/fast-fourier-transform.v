import math.complex
import math
fn ditfft2(x []f64, mut y []Complex, n int, s int) {
    if n == 1 {
        y[0] = complex(x[0], 0)
        return
    }
    ditfft2(x, mut y, n/2, 2*s)
    ditfft2(x[s..], mut y[n/2..], n/2, 2*s)
    for k := 0; k < n/2; k++ {
        tf := cmplx.Rect(1, -2*math.pi*f64(k)/f64(n)) * y[k+n/2]
        y[k], y[k+n/2] = y[k]+tf, y[k]-tf
    }
}

fn main() {
    x := [f64(1), 1, 1, 1, 0, 0, 0, 0]
    mut y := []Complex{len: x.len}
    ditfft2(x, mut y, x.len, 1)
    for c in y {
        println("${c:8.4f}")
    }
}
