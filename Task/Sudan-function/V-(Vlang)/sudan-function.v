fn sudan(n int, x int, y int) int {
    if n == 0 {
       return x + y
    }
    if y == 0 {
        return x
    }
    return sudan(n-1, sudan(n, x, y-1), sudan(n, x, y-1) + y)
}

fn main() {
    for n := 0; n < 2; n++ {
        println("Values of F($n, x, y):")
        println("y/x    0   1   2   3   4   5")
        println("----------------------------")
        for y := 0; y < 7; y++ {
            print("$y  |")
            for x := 0; x < 6; x++ {
                s := sudan(n, x, y)
                print("${s:4}")
            }
            println('')
        }
        println('')
    }
    println("F(2, 1, 1) = ${sudan(2, 1, 1)}")
    println("F(3, 1, 1) = ${sudan(3, 1, 1)}")
    println("F(2, 2, 1) = ${sudan(2, 2, 1)}")
}
