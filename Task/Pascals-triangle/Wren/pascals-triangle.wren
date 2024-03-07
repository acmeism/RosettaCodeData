import "./fmt" for Fmt
import "./math" for Int

var pascalTriangle = Fn.new { |n|
    if (n <= 0) return
    for (i in 0...n) {
        System.write("   " * (n-i-1))
        for (j in 0..i) {
            Fmt.write("$3d   ", Int.binomial(i, j))
        }
        System.print()
    }
}

pascalTriangle.call(13)
