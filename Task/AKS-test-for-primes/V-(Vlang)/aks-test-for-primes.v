fn bc(p int) []i64 {
    mut c := []i64{len: p+1}
    mut r := i64(1)
    for i, half := 0, p/2; i <= half; i++ {
        c[i] = r
        c[p-i] = r
        r = r * i64(p-i) / i64(i+1)
    }
    for i := p - 1; i >= 0; i -= 2 {
        c[i] = -c[i]
    }
    return c
}

fn main() {
    for p := 0; p <= 7; p++ {
        println("$p:  ${pp(bc(p))}")
    }
    for p := 2; p < 50; p++ {
        if aks(p) {print("${p} ")}
    }
    println("")
}

const e = [`²`,`³`,`⁴`,`⁵`,`⁶`,`⁷`]

fn pp(c []i64) string {
    mut s := ''
    if c.len == 1 {return c[0].str()}
    p := c.len - 1
    if c[p] != 1 {s = c[p].str()}
    for i := p; i > 0; i-- {
        s += "x"
        if i != 1 {s += e[i-2].str()}
        d := c[i-1]
        if d < 0 {s += " - ${-d}"}
        else {s += " + $d"}
    }
    return s
}

fn aks(p int) bool {
    mut c := bc(p)
    c[p]--
    c[0]++
    for d in c {
        if d%i64(p) != 0 {return false}
    }
    return true
}
