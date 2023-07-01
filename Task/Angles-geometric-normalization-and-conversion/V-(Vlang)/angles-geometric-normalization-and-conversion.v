import math
import strconv
fn d2d(d f64) f64 { return math.mod(d, 360) }
fn g2g(g f64) f64 { return math.mod(g, 400) }
fn m2m(m f64) f64 { return math.mod(m, 6400) }
fn r2r(r f64) f64 { return math.mod(r, 2*math.pi) }
fn d2g(d f64) f64 { return d2d(d) * 400 / 360 }
fn d2m(d f64) f64 { return d2d(d) * 6400 / 360 }
fn d2r(d f64) f64 { return d2d(d) * math.pi / 180 }
fn g2d(g f64) f64 { return g2g(g) * 360 / 400 }
fn g2m(g f64) f64 { return g2g(g) * 6400 / 400 }
fn g2r(g f64) f64 { return g2g(g) * math.pi / 200 }
fn m2d(m f64) f64 { return m2m(m) * 360 / 6400 }
fn m2g(m f64) f64 { return m2m(m) * 400 / 6400 }
fn m2r(m f64) f64 { return m2m(m) * math.pi / 3200 }
fn r2d(r f64) f64 { return r2r(r) * 180 / math.pi }
fn r2g(r f64) f64 { return r2r(r) * 200 / math.pi }
fn r2m(r f64) f64 { return r2r(r) * 3200 / math.pi }

fn s(f f64) string {
    wf := strconv.format_fl(f, strconv.BF_param{
        len0: 15
        len1: 7
        positive: f>=0
    }).split('.')
    if wf[1] == '0000000' {
        return "${wf[0]:7}        "
    }
    mut le := wf[1].len
    if le > 7 {
        le = 7
    }
    return "${wf[0]:7}.${wf[1][..le]:-7}"
}
fn main() {
    angles := [-2.0, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000]
    println("    degrees     normalized degs     gradians         mils            radians")
    for a in angles {
        println('${s(a)} ${s(d2d(a))} ${s(d2g(a))} ${s(d2m(a))} ${s(d2r(a))}')
    }
    println("\n   gradians     normalized grds     degrees          mils            radians")
    for a in angles {
        println('${s(a)} ${s(g2g(a))} ${s(g2d(a))} ${s(g2m(a))} ${s(g2r(a))}')
    }
    println("\n     mils       normalized mils     degrees        gradians          radians")
    for a in angles {
        println('${s(a)} ${s(m2m(a))} ${s(m2d(a))} ${s(m2g(a))} ${s(m2r(a))}')
    }
    println("\n    radians     normalized rads     degrees        gradians           mils  ")
    for a in angles {
        println('${s(a)} ${s(r2r(a))} ${s(r2d(a))} ${s(r2g(a))} ${s(r2m(a))}')
    }
}
