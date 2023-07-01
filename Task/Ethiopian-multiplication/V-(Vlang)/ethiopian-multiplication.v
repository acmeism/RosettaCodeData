fn halve(i int) int { return i/2 }

fn double(i int) int { return i*2 }

fn is_even(i int) bool { return i%2 == 0 }

fn eth_multi(ii int, jj int) int {
    mut r := 0
    mut i, mut j := ii, jj
    for ; i > 0; i, j = halve(i), double(j) {
        if !is_even(i) {
            r += j
        }
    }
    return r
}

fn main() {
    println("17 ethiopian 34 = ${eth_multi(17, 34)}")
}
