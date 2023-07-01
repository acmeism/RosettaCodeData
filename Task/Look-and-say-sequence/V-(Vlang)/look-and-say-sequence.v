fn lss(s string) string {
    mut r := ''
    mut c := s[0..1]
    mut nc := 1
    for i := 1; i < s.len; i++ {
        d := s[i..i+1]
        if d == c {
            nc++
            continue
        }
        r += nc.str() + c
        c = d
        nc = 1
    }
    return r + nc.str() + c
}

fn main() {
    mut s := "1"
    println(s)
    for i := 0; i < 8; i++ {
        s = lss(s)
        println(s)
    }
}
