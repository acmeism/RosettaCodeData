fn is_prime(n int) bool {
    return n == 2 || n == 3 || n == 5 || n == 7 || n == 11 || n == 13 || n == 17
}

fn main() {
    mut count := 0
    mut d := []int{}
    println("Strange plus numbers in the open interval (100, 500) are:\n")
    for i := 101; i < 500; i++ {
        d = d[..0].clone()
        mut j := i
        for j > 0 {
            d << j%10
            j /= 10
        }
        if is_prime(d[0]+d[1]) && is_prime(d[1]+d[2]) {
            print("$i ")
            count++
            if count%10 == 0 {
                println('')
            }
        }
    }
    if count%10 != 0 {
        println('')
    }
    println("\n$count strange plus numbers in all.")
}
