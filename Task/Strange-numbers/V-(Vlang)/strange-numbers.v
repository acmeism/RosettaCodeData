fn is_prime(nn int) bool {
    mut n := nn
    if n < 0 {
        n = -n
    }
    return n == 2 || n == 3 || n == 5 || n == 7
}

fn main() {
    mut count := 0
    mut d := []int{}
    println("Strange numbers in the open interval (100, 500) are:\n")
    for i in 101..500{
        d = d[..0]
        mut j := i
        for j > 0 {
            d << j%10
            j /= 10
        }
        if is_prime(d[0]-d[1]) && is_prime(d[1]-d[2]) {
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
    println("\n$count strange numbers in all.")
}
