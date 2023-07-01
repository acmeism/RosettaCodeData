fn k_prime(n int, k int) bool {
    mut nf := 0
    mut nn := n
    for i in 2 .. nn+1 {
        for nn % i == 0 {
            if nf == k {
                return false
            }
            nf++
            nn/=i
        }
    }
    return nf == k
}

fn gen(k int, n int) []int {
    mut r := []int{len:n}
    mut nx := 2
    for i in 0 .. n {
        for !k_prime(nx, k) {
            nx++
        }
        r[i] = nx
        nx++
    }
    return r
}

fn main(){
    for k in 1..6 {
        println('$k ${gen(k,10)}')
    }
}
