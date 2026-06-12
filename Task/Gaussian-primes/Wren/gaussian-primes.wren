import "dome" for Window
import "graphics" for Canvas, Color
import "./plot" for Axes
import "./complex" for Complex
import "./math2" for Int
import "./fmt" for Fmt

var norm = Fn.new { |c| c.real * c.real + c.imag * c.imag }

var GPrimes = []
var Radius = 150
for (r in -Radius+1...Radius) {
    for (i in -Radius+1...Radius) {
        if (i == 0) {
            var m = r.abs
            if (Int.isPrime(m) && (m - 3) % 4 == 0) GPrimes.add(Complex.new(r))
        } else if (r == 0) {
            var m = i.abs
            if (Int.isPrime(m) && (m - 3) % 4 == 0) GPrimes.add(Complex.new(0, i))
        } else {
           var n = r * r + i * i
           if (n < Radius * Radius && Int.isPrime(n)) GPrimes.add(Complex.new(r, i))
        }
    }
}

var gp10 = GPrimes.where { |p| norm.call(p) < 100 }.toList
gp10.sort { |i, j|
    var ni = norm.call(i)
    var nj = norm.call(j)
    if (ni != nj) return ni < nj
    if (i.real != j.real) return i.real > j.real
    return i.imag > j.imag
}
System.print("Gaussian primes with a norm less than 100 sorted by norm:")
Fmt.tprint("($ 0.0z) ", gp10, 5)
GPrimes = GPrimes.map { |c| c.toPair }.toList

class Main {
    construct new() {
        Window.title = "Gaussian primes"
        Canvas.resize(1000, 1000)
        Window.resize(1000, 1000)
        Canvas.cls(Color.black)
        var axes = Axes.new(100, 900, 800, 800, -Radius..Radius, -Radius..Radius)
        axes.plot(GPrimes, Color.yellow, "·")
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
