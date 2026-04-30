const n = 64

fn pow2(x u32) u64 {
    return u64(1) << x
}

fn evolve(p_state u64, rule int) {
	mut state := p_state
	mut t1, mut t2, mut t3, mut b := u64(0), u64(0), u64(0), u64(0)
    for _ in 0 .. 10 {
        b = 0
        for q := 7; q >= 0; q-- {
            st := state
            b |= (st & 1) << u32(q)
            state = 0
            for i := u32(0); i < n; i++ {
                if i > 0 { t1 = st >> (i - 1) } else { t1 = st >> 63 }
                if i == 0 { t2 = st << 1 }
                else if i == 1 { t2 = st << 63 }
                else { t2 = st << (n + 1 - i) }
                t3 = 7 & (t1 | t2)
                if (u64(rule) & pow2(u32(t3))) != 0 { state |= pow2(i) }
            }
        }
        print('$b ')
    }
    println('')
}

fn main() {
    evolve(1, 30)
}
