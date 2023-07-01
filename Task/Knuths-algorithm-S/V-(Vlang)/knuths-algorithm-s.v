import rand
import rand.seed
fn s_of_ncreator(n int) fn(u8) []u8 {
    mut s := []u8{len: 0, cap:n}
    mut m := n
    return fn[mut s, mut m, n](item u8) []u8 {
        if s.len < n {
            s << item
        } else {
            m++
            if rand.intn(m) or {0} < n {
                s[rand.intn(n) or {0}] = item
            }
        }
        return s
    }
}

fn main() {
    rand.seed(seed.time_seed_array(2))
    mut freq := [10]int{}
    for _ in 0..int(1e5) {
        s_of_n := s_of_ncreator(3)
        for d := '0'[0]; d < '9'[0]; d++ {
            s_of_n(d)
        }
        for d in s_of_n('9'[0]) {
            freq[d-'0'[0]]++
        }
    }
    println(freq)
}
