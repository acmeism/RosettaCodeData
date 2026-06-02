fn F(n: int, x: int, y: int) -> int {
    if n == 0 { return x + y; }
    if y == 0 { return x; }
    return F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y);
}

fn main() {
    for n in 0..2 {
        println "Values of F({n}, x, y):";
        println "y/x    0   1   2   3   4   5";
        println "----------------------------";
        for y in 0..7 {
            print "{y}  |";
            for x in 0..6 {
                let sudan = F(n, x, y);
                print "{sudan:4d}";
            }
            println "";
        }
        println "";
    }
    println "F(2, 1, 1) = {F(2, 1, 1)}";
    println "F(3, 1, 1) = {F(3, 1, 1)}";
    println "F(2, 2, 1) = {F(2, 2, 1)}";
}
