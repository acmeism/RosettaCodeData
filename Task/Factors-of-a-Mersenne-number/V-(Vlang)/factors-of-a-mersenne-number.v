import math
const qlimit = int(2e8)

fn main() {
    mtest(31)
    mtest(67)
    mtest(929)
}

fn mtest(m int) {
    // the function finds odd prime factors by
    // searching no farther than sqrt(N), where N = 2^m-1.
    // the first odd prime is 3, 3^2 = 9, so M3 = 7 is still too small.
    // M4 = 15 is first number for which test is meaningful.
    if m < 4 {
        println("$m < 4.  M$m not tested.")
        return
    }
    flimit := math.sqrt(math.pow(2, f64(m)) - 1)
    mut qlast := 0
    if flimit < qlimit {
        qlast = int(flimit)
    } else {
        qlast = qlimit
    }
    mut composite := []bool{len: qlast+1}
    sq := int(math.sqrt(f64(qlast)))
loop:
    for q := int(3); ; {
        if q <= sq {
            for i := q * q; i <= qlast; i += q {
                composite[i] = true
            }
        }
        q8 := q % 8
        if (q8 == 1 || q8 == 7) && mod_pow(2, m, q) == 1 {
            println("M$m has factor $q")
            return
        }
        for {
            q += 2
            if q > qlast {
                break loop
            }
            if !composite[q] {
                break
            }
        }
    }
    println("No factors of M$m found.")
}

// base b to power p, mod m
fn mod_pow(b int, p int, m int) int {
    mut pow := i64(1)
    b64 := i64(b)
    m64 := i64(m)
    mut bit := u32(30)
    for 1<<bit&p == 0 {
        bit--
    }
    for {
        pow *= pow
        if 1<<bit&p != 0 {
            pow *= b64
        }
        pow %= m64
        if bit == 0 {
            break
        }
        bit--
    }
    return int(pow)
}
