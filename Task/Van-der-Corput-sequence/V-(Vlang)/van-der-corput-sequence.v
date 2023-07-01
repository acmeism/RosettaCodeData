fn v2(nn u32) f64 {
    mut n:=nn
    mut r := f64(0)
    mut p := .5
    for n > 0 {
        if n&1 == 1 {
            r += p
        }
        p *= .5
        n >>= 1
    }
    return r
}

fn new_v(base u32) fn(u32) f64 {
    invb := 1 / f64(base)
    return fn[base,invb](nn u32) f64 {
        mut n:=nn
        mut r := f64(0)
        mut p := invb
        for n > 0 {
            r += p * f64(n%base)
            p *= invb
            n /= base
        }
        return r
    }
}

fn main() {
    println("Base 2:")
    for i := u32(0); i < 10; i++ {
        println('$i ${v2(i)}')
    }
    println("Base 3:")
    v3 := new_v(3)
    for i := u32(0); i < 10; i++ {
        println('$i ${v3(i)}')
    }
}
