package main

import (
    "fmt"
    "math"
    "math/cmplx"
)

func fft(buf []complex128, n int) {
    out := make([]complex128, n)
    copy(out, buf)
    fft2(buf, out, n, 1)
}

func fft2(buf, out []complex128, n, step int) {
    if step < n {
        fft2(out, buf, n, step*2)
        fft2(out[step:], buf[step:], n, step*2)
        for j := 0; j < n; j += 2 * step {
            fj, fn := float64(j), float64(n)
            t := cmplx.Exp(-1i*complex(math.Pi, 0)*complex(fj, 0)/complex(fn, 0)) * out[j+step]
            buf[j/2] = out[j] + t
            buf[(j+n)/2] = out[j] - t
        }
    }
}

/* pad slice length to power of two */
func padTwo(g []float64, le int, ns *int) []complex128 {
    n := 1
    if *ns != 0 {
        n = *ns
    } else {
        for n < le {
            n *= 2
        }
    }
    buf := make([]complex128, n)
    for i := 0; i < le; i++ {
        buf[i] = complex(g[i], 0)
    }
    *ns = n
    return buf
}

func deconv(g []float64, lg int, f []float64, lf int, out []float64, rowLe int) {
    ns := 0
    g2 := padTwo(g, lg, &ns)
    f2 := padTwo(f, lf, &ns)
    fft(g2, ns)
    fft(f2, ns)
    h := make([]complex128, ns)
    for i := 0; i < ns; i++ {
        h[i] = g2[i] / f2[i]
    }
    fft(h, ns)
    for i := 0; i < ns; i++ {
        if math.Abs(real(h[i])) < 1e-10 {
            h[i] = 0
        }
    }
    for i := 0; i > lf-lg-rowLe; i-- {
        out[-i] = real(h[(i+ns)%ns] / 32)
    }
}

func unpack2(m [][]float64, rows, le, toLe int) []float64 {
    buf := make([]float64, rows*toLe)
    for i := 0; i < rows; i++ {
        for j := 0; j < le; j++ {
            buf[i*toLe+j] = m[i][j]
        }
    }
    return buf
}

func pack2(buf []float64, rows, fromLe, toLe int, out [][]float64) {
    for i := 0; i < rows; i++ {
        for j := 0; j < toLe; j++ {
            out[i][j] = buf[i*fromLe+j] / 4
        }
    }
}

func deconv2(g [][]float64, rowG, colG int, f [][]float64, rowF, colF int, out [][]float64) {
    g2 := unpack2(g, rowG, colG, colG)
    f2 := unpack2(f, rowF, colF, colG)
    ff := make([]float64, (rowG-rowF+1)*colG)
    deconv(g2, rowG*colG, f2, rowF*colG, ff, colG)
    pack2(ff, rowG-rowF+1, colG, colG-colF+1, out)
}

func unpack3(m [][][]float64, x, y, z, toY, toZ int) []float64 {
    buf := make([]float64, x*toY*toZ)
    for i := 0; i < x; i++ {
        for j := 0; j < y; j++ {
            for k := 0; k < z; k++ {
                buf[(i*toY+j)*toZ+k] = m[i][j][k]
            }
        }
    }
    return buf
}

func pack3(buf []float64, x, y, z, toY, toZ int, out [][][]float64) {
    for i := 0; i < x; i++ {
        for j := 0; j < toY; j++ {
            for k := 0; k < toZ; k++ {
                out[i][j][k] = buf[(i*y+j)*z+k] / 4
            }
        }
    }
}

func deconv3(g [][][]float64, gx, gy, gz int, f [][][]float64, fx, fy, fz int, out [][][]float64) {
    g2 := unpack3(g, gx, gy, gz, gy, gz)
    f2 := unpack3(f, fx, fy, fz, gy, gz)
    ff := make([]float64, (gx-fx+1)*gy*gz)
    deconv(g2, gx*gy*gz, f2, fx*gy*gz, ff, gy*gz)
    pack3(ff, gx-fx+1, gy, gz, gy-fy+1, gz-fz+1, out)
}

func main() {
    f := [][][]float64{
        {{-9, 5, -8}, {3, 5, 1}},
        {{-1, -7, 2}, {-5, -6, 6}},
        {{8, 5, 8}, {-2, -6, -4}},
    }
    fx, fy, fz := len(f), len(f[0]), len(f[0][0])

    g := [][][]float64{
        {{54, 42, 53, -42, 85, -72}, {45, -170, 94, -36, 48, 73},
            {-39, 65, -112, -16, -78, -72}, {6, -11, -6, 62, 49, 8}},
        {{-57, 49, -23, 52, -135, 66}, {-23, 127, -58, -5, -118, 64},
            {87, -16, 121, 23, -41, -12}, {-19, 29, 35, -148, -11, 45}},
        {{-55, -147, -146, -31, 55, 60}, {-88, -45, -28, 46, -26, -144},
            {-12, -107, -34, 150, 249, 66}, {11, -15, -34, 27, -78, -50}},
        {{56, 67, 108, 4, 2, -48}, {58, 67, 89, 32, 32, -8},
            {-42, -31, -103, -30, -23, -8}, {6, 4, -26, -10, 26, 12},
        },
    }
    gx, gy, gz := len(g), len(g[0]), len(g[0][0])

    h := [][][]float64{
        {{-6, -8, -5, 9}, {-7, 9, -6, -8}, {2, -7, 9, 8}},
        {{7, 4, 4, -6}, {9, 9, 4, -4}, {-3, 7, -2, -3}},
    }
    hx, hy, hz := gx-fx+1, gy-fy+1, gz-fz+1

    h2 := make([][][]float64, hx)
    for i := 0; i < hx; i++ {
        h2[i] = make([][]float64, hy)
        for j := 0; j < hy; j++ {
            h2[i][j] = make([]float64, hz)
        }
    }
    deconv3(g, gx, gy, gz, f, fx, fy, fz, h2)
    fmt.Println("deconv3(g, f):\n")
    for i := 0; i < hx; i++ {
        for j := 0; j < hy; j++ {
            for k := 0; k < hz; k++ {
                fmt.Printf("% .10g  ", h2[i][j][k])
            }
            fmt.Println()
        }
        if i < hx-1 {
            fmt.Println()
        }
    }

    kx, ky, kz := gx-hx+1, gy-hy+1, gz-hz+1
    f2 := make([][][]float64, kx)
    for i := 0; i < kx; i++ {
        f2[i] = make([][]float64, ky)
        for j := 0; j < ky; j++ {
            f2[i][j] = make([]float64, kz)
        }
    }
    deconv3(g, gx, gy, gz, h, hx, hy, hz, f2)
    fmt.Println("\ndeconv(g, h):\n")
    for i := 0; i < kx; i++ {
        for j := 0; j < ky; j++ {
            for k := 0; k < kz; k++ {
                fmt.Printf("% .10g  ", f2[i][j][k])
            }
            fmt.Println()
        }
        if i < kx-1 {
            fmt.Println()
        }
    }
}
