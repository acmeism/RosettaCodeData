// 1st arg is the number to generate the sequence for.
// 2nd arg is a slice to recycle, to reduce garbage.
fn hs(nn int, recycle []int) []int {
    mut n := nn
    mut s := recycle[..0]
    s << n
    for n > 1 {
        if n&1 == 0 {
            n /= 2
        } else {
            n = 3*n + 1
        }
        s << n
    }
    return s
}

fn main() {
    mut seq := hs(27, [])
    println("hs(27): $seq.len elements: [${seq[0]} ${seq[1]} ${seq[2]} ${seq[3]} ... ${seq[seq.len-4]} ${seq[seq.len-3]} ${seq[seq.len-2]} ${seq[seq.len-1]}]")

    mut max_n, mut max_len := 0,0
    for n in 1..100000 {
        seq = hs(n, seq)
        if seq.len > max_len {
            max_n = n
            max_len = seq.len
        }
    }
    println("hs($max_n): $max_len elements")
}
