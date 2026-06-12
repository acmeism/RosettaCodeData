import "dome" for Window
import "graphics" for Canvas, Color
import "./plot" for Axes
import "./iterate" for Stepped
import "./complex" for Complex
import "./math2" for Math, Int
import "./fmt" for Fmt

var OMEGA = Complex.new(-0.5, 3.sqrt * 0.5)

class Eisenstein {
    construct new(a, b) {
        _a = a
        _b = b
        _n = OMEGA * b + a
    }

    a { _a }
    b { _b }
    n { _n }

    real { _n.real }
    imag { _n.imag }
    norm { _a *_a - _a * _b + _b * _b }

    isPrime {
        if (_a == 0 || _b == 0 || _a == _b) {
            var c = Math.max(_a.abs, _b.abs)
            return Int.isPrime(c) && c % 3 == 2
        }
        return Int.isPrime(norm)
    }

    toString { _n.toString }
}

var eprimes = []
for (a in -100..100) {
    for (b in -100..100) {
        var e = Eisenstein.new(a, b)
        if (e.isPrime) eprimes.add(e)
    }
}

// try to replicate Julia sort order for easy comparison
eprimes.sort { |e1, e2|
    if (e1.norm < e2.norm) return true
    if (e1.norm == e2.norm) {
        if (e1.imag < e2.imag) return true
        if (e1.imag == e2.imag) return e1.real < e2.real
        return false
    }
    return false
}

// convert to Complex numbers for easy display
eprimes = eprimes.map { |e| e.n }

// display first 100 to terminal
System.print("First 100 Eisenstein primes nearest zero:")
Fmt.tprint("$ 6.4z ", eprimes.take(100), 4)

// generate points for the plot
var Pts = eprimes.map { |e| [e.real, e.imag] }.toList

class Main {
    construct new() {
        Window.title = "Eisenstein primes with norm <= 100  (%(Pts.count) points)"
        Canvas.resize(1000, 600)
        Window.resize(1000, 600)
        Canvas.cls(Color.white)
        var axes = Axes.new(100, 500, 800, 400, -160..160, -100..100)
        axes.draw(Color.black, 2)
        var xMarks = Stepped.new(-150..150, 50)
        var yMarks = Stepped.new(-75..75, 25)
        axes.mark(xMarks, yMarks, Color.black, 2)
        axes.label(xMarks, yMarks, Color.black, 2, Color.black)
        axes.plot(Pts, Color.black, "·") // uses interpunct character 0xb7
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
