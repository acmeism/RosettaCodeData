fn main() {
    println("1: 1")
    for i := 2; ; i++ {
        print("$i: ")
        mut x := ''
        for n, f := i, 2; n != 1; f++ {
            for m := n % f; m == 0; m = n % f {
                print('$x$f')
                x = "×"
                n /= f
            }
        }
        println('')
    }
}
