import math.big

fn bell_triangle(n int) [][]big.Integer {
    mut tri := [][]big.Integer{len: n}
    for i in 0..n {
        tri[i] = []big.Integer{len: i}
        for j in 0..i {
            tri[i][j] = big.zero_int
        }
    }
    tri[1][0] = big.integer_from_u64(1)
    for i in 2..n {
        tri[i][0] = tri[i-1][i-2]
        for j := 1; j < i; j++ {
            tri[i][j] = tri[i][j-1] + tri[i-1][j-1]
        }
    }
    return tri
}

fn main() {
    bt := bell_triangle(51)
    println("First fifteen and fiftieth Bell numbers:")
    for i := 1; i <= 15; i++ {
        println("${i:2}: ${bt[i][0]}")
    }
    println("50: ${bt[50][0]}")
    println("\nThe first ten rows of Bell's triangle:")
    for i := 1; i <= 10; i++ {
        println(bt[i])
    }
}
