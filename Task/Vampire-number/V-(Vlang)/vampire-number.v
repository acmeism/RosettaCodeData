import math
fn max(a u64, b u64) u64 {
    if a > b {
        return a
    }
    return b
}

fn min(a u64, b u64) u64 {
    if a < b {
        return a
    }
    return b
}

fn ndigits(xx u64) int {
    mut n:=0
    mut x := xx
    for ; x > 0; x /= 10 {
        n++
    }
    return n
}

fn dtally(xx u64) u64 {
    mut t := u64(0)
    mut x := xx
    for ; x > 0; x /= 10 {
        t += 1 << (x % 10 * 6)
    }
    return t
}

__global (
    tens [20]u64
)

fn init() {
    tens[0] = 1
    for i := 1; i < 20; i++ {
        tens[i] = tens[i-1] * 10
    }
}

fn fangs(x u64) []u64 {
    mut f := []u64{}
    mut nd := ndigits(x)
    if nd&1 == 1 {
        return f
    }
    nd /= 2
    lo := max(tens[nd-1], (x+tens[nd]-2)/(tens[nd]-1))
    hi := min(x/lo, u64(math.sqrt(f64(x))))
    t := dtally(x)
    for a := lo; a <= hi; a++ {
        b := x / a
        if a*b == x &&
            (a%10 > 0 || b%10 > 0) &&
            t == dtally(a)+dtally(b) {
            f << a
        }
    }
    return f
}

fn show_fangs(x u64, f []u64) {
    print(x)
    if f.len > 1 {
        println('')
    }
    for a in f {
        println(" = $a × ${x/a}")
    }
}

fn main() {
    for x, n := u64(1), 0; n < 26; x++ {
        f := fangs(x)
        if f.len > 0 {
            n++
            print("${n:2}: ")
            show_fangs(x, f)
        }
    }
    println('')
    for x in [u64(16758243290880), 24959017348650, 14593825548650] {
        f := fangs(x)
        if f.len > 0 {
            show_fangs(x, f)
        } else {
            println("$x is not vampiric")
        }
    }
}
