fn special_matrix(n int) {
    for i in 0..n {
        for j in 0..n {
            if i == j || i+j == n-1 {
                print("1 ")
            } else {
                print("0 ")
            }
        }
        println('')
    }
}

fn main() {
    special_matrix(6) // even n
    println('')
    special_matrix(5) // odd n
}
