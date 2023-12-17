import "./fmt" for Fmt
import "./math" for Math

var stirling = Fn.new { |x| (2 * Num.pi / x).sqrt * (x / Math.e).pow(x) }

System.print(" x\tStirling\t\tLanczos\n")
for (i in 1..20) {
    var d = i / 10
    Fmt.print("$4.2f\t$16.14f\t$16.14f", d, stirling.call(d), Math.gamma(d))
}
