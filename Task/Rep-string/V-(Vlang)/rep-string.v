fn rep(s string) int {
    for x := s.len / 2; x > 0; x-- {
        if s.starts_with(s[x..]) {
            return x
        }
    }
    return 0
}

const m = '
1001110011
1110111011
0010010010
1010101010
1111111111
0100101101
0100100
101
11
00
1'

fn main() {
    for s in m.fields() {
        n := rep(s)
        if n > 0 {
            println("$s  $n rep-string ${s[..n]}")
        } else {
            println("$s  not a rep-string")
        }
    }
}
