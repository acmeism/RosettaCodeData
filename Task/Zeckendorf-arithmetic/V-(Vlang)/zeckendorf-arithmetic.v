import strings
const (
    dig  = ["00", "01", "10"]
    dig1 = ["", "1", "10"]
)

struct Zeckendorf {
mut:
    d_val int
    d_len int
}

fn new_zeck(xx string) Zeckendorf {
    mut z := Zeckendorf{}
    mut x := xx
    if x == "" {
        x = "0"
    }
    mut q := 1
    mut i := x.len - 1
    z.d_len = i / 2
    for ; i >= 0; i-- {
        z.d_val += int(x[i]-'0'[0]) * q
        q *= 2
    }
    return z
}

fn (mut z Zeckendorf) a(ii int) {
    mut i:=ii
    for ; ; i++ {
        if z.d_len < i {
            z.d_len = i
        }
        j := (z.d_val >> u32(i*2)) & 3
        if j in [0, 1] {
            return
        } else if j==2 {
            if ((z.d_val >> (u32(i+1) * 2)) & 1) != 1 {
                return
            }
            z.d_val += 1 << u32(i*2+1)
            return
        } else {// 3
            z.d_val &= ~(3 << u32(i*2))
            z.b((i + 1) * 2)
        }
    }
}

fn (mut z Zeckendorf) b(p int) {
    mut pos := p
    if pos == 0 {
        z.inc()
        return
    }
    if ((z.d_val >> u32(pos)) & 1) == 0 {
        z.d_val += 1 << u32(pos)
        z.a(pos / 2)
        if pos > 1 {
            z.a(pos/2 - 1)
        }
    } else {
        z.d_val &= ~(1 << u32(pos))
        z.b(pos + 1)
        mut temp := 1
        if pos > 1 {
            temp = 2
        }
        z.b(pos - temp)
    }
}

fn (mut z Zeckendorf) c(p int) {
    mut pos := p
    if ((z.d_val >> u32(pos)) & 1) == 1 {
        z.d_val &= ~(1 << u32(pos))
        return
    }
    z.c(pos + 1)
    if pos > 0 {
        z.b(pos - 1)
    } else {
        z.inc()
    }
}

fn (mut z Zeckendorf) inc() {
    z.d_val++
    z.a(0)
}

fn (mut z1 Zeckendorf) plus_assign(z2 Zeckendorf) {
    for gn := 0; gn < (z2.d_len+1)*2; gn++ {
        if ((z2.d_val >> u32(gn)) & 1) == 1 {
            z1.b(gn)
        }
    }
}

fn (mut z1 Zeckendorf) minus_assign(z2 Zeckendorf) {
    for gn := 0; gn < (z2.d_len+1)*2; gn++ {
        if ((z2.d_val >> u32(gn)) & 1) == 1 {
            z1.c(gn)
        }
    }

    for z1.d_len > 0 && ((z1.d_val>>u32(z1.d_len*2))&3) == 0 {
        z1.d_len--
    }
}

fn (mut z1 Zeckendorf) times_assign(z2 Zeckendorf) {
    mut na := z2.copy()
    mut nb := z2.copy()
    mut nr := Zeckendorf{}
    for i := 0; i <= (z1.d_len+1)*2; i++ {
        if ((z1.d_val >> u32(i)) & 1) > 0 {
            nr.plus_assign(nb)
        }
        nt := nb.copy()
        nb.plus_assign(na)
        na = nt.copy()
    }
    z1.d_val = nr.d_val
    z1.d_len = nr.d_len
}

fn (z Zeckendorf) copy() Zeckendorf {
    return Zeckendorf{z.d_val, z.d_len}
}

fn (z1 Zeckendorf) compare(z2 Zeckendorf) int {
    if z1.d_val < z2.d_val {
        return -1
    } else if z1.d_val > z2.d_val {
        return 1
    } else {
        return 0
    }
}

fn (z Zeckendorf) str() string {
    if z.d_val == 0 {
        return "0"
    }
    mut sb := strings.new_builder(128)
    sb.write_string(dig1[(z.d_val>>u32(z.d_len*2))&3])
    for i := z.d_len - 1; i >= 0; i-- {
        sb.write_string(dig[(z.d_val>>u32(i*2))&3])
    }
    return sb.str()
}

fn main() {
    println("Addition:")
    mut g := new_zeck("10")
    g.plus_assign(new_zeck("10"))
    println(g)
    g.plus_assign(new_zeck("10"))
    println(g)
    g.plus_assign(new_zeck("1001"))
    println(g)
    g.plus_assign(new_zeck("1000"))
    println(g)
    g.plus_assign(new_zeck("10101"))
    println(g)

    println("\nSubtraction:")
    g = new_zeck("1000")
    g.minus_assign(new_zeck("101"))
    println(g)
    g = new_zeck("10101010")
    g.minus_assign(new_zeck("1010101"))
    println(g)

    println("\nMultiplication:")
    g = new_zeck("1001")
    g.times_assign(new_zeck("101"))
    println(g)
    g = new_zeck("101010")
    g.plus_assign(new_zeck("101"))
    println(g)
}
