import "dome" for Window
import "graphics" for Canvas, Color
import "./math2" for Int
import "./iterate" for Stepped
import "./fmt" for Fmt
import "./plot" for Axes

var limit = 4002
var primes = Int.primeSieve(limit-1).skip(1).toList
var goldbach = {4: 1}
for (i in Stepped.new(6..limit, 2)) goldbach[i] = 0
for (i in 0...primes.count) {
    for (j in i...primes.count) {
        var s = primes[i] + primes[j]
        if (s > limit) break
        goldbach[s] = goldbach[s] + 1
    }
}

System.print("The first 100 G values:")
var count = 0
for (i in Stepped.new(4..202, 2)) {
    count = count + 1
    Fmt.write("$2d ", goldbach[i])
    if (count % 10 == 0) System.print()
}

primes = Int.primeSieve(499999).skip(1)
var gm = 0
for (p in primes) {
    if (Int.isPrime(1e6 - p)) gm = gm + 1
}
System.print("\nG(1000000) = %(gm)")

var Red   = []
var Blue  = []
var Green = []

// create lists for the first 2000 G values for plotting by DOME.
for(e in Stepped.new(4..limit, 2)) {
    var c = e % 6
    var n = e/2 - 1
    if (c == 0) {
        Red.add([n, goldbach[e]])
    } else if (c == 2) {
        Blue.add([n, goldbach[e]])
    } else {
        Green.add([n, goldbach[e]])
    }
}

class Main {
    construct new() {
        Window.title = "Goldbach's comet"
        Canvas.resize(1000, 600)
        Window.resize(1000, 600)
        Canvas.cls(Color.white)
        var axes = Axes.new(100, 500, 800, 400, 0..2000, 0..200)
        axes.draw(Color.black, 2)
        var xMarks = Stepped.new(0..2000, 200)
        var yMarks = Stepped.new(0..200, 20)
        axes.mark(xMarks, yMarks, Color.black, 2)
        var xMarks2 = Stepped.new(0..2000, 400)
        var yMarks2 = Stepped.new(0..200, 40)
        axes.label(xMarks2, yMarks2, Color.black, 2, Color.black)
        axes.plot(Red, Color.red, "+")
        axes.plot(Blue, Color.blue, "+")
        axes.plot(Green, Color.green, "+")
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
