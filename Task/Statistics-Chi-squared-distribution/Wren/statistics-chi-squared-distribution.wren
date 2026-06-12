import "dome" for Window
import "graphics" for Canvas, Color
import "./math2" for Math
import "./iterate" for Stepped
import "./fmt" for Fmt
import "./plot" for Axes

class Chi2 {
    static pdf(x, k) {
        if (x <= 0) return 0
        return (-x/2).exp * x.pow(k/2-1) / (2.pow(k/2) * Math.gamma(k/2))
    }

    static cpdf(x, k) {
        var t = (-x/2).exp * (x/2).pow(k/2)
        var s = 0
        var m = 0
        var tol = 1e-15 // say
        while (true) {
            var term = (x/2).pow(m) / Math.gamma(k/2 + m + 1)
            s = s + term
            if (term.abs < tol) break
            m = m + 1
        }
        return t * s
    }
}

System.print("    Values of the χ2 probability distribution function")
System.print(" x/k    1         2         3         4         5")
for (x in 0..10) {
    Fmt.write("$2d  ", x)
    for (k in 1..5) {
        Fmt.write("$f  ", Chi2.pdf(x, k))
    }
    System.print()
}

System.print("\n    Values for χ2 with 3 degrees of freedom")
System.print("χ2  cum pdf   p-value")
for (x in [1, 2, 4, 8, 16, 32]) {
    var cpdf = Chi2.cpdf(x, 3)
    Fmt.print("$2d  $f  $f", x,  cpdf, 1-cpdf)
}

var airport = [[77, 23], [88, 12], [79, 21], [81, 19]]
var expected = [81.25, 18.75]
var dsum = 0
for (i in 0...airport.count) {
    for (j in 0...airport[0].count) {
        dsum = dsum + (airport[i][j] - expected[j]).pow(2) / expected[j]
    }
}
var dof = (airport.count - 1) / (airport[0].count - 1)
System.print("\nFor airport data table: ")
Fmt.print("  diff sum : $f", dsum)
Fmt.print("  d.o.f.   : $d", dof)
Fmt.print("  χ2 value : $f", Chi2.pdf(dsum, dof))
Fmt.print("  p-value  : $f", Chi2.cpdf(dsum, dof))

// generate points for plot
var Pts = List.filled(5, null)
for (k in 0..4) {
    Pts[k] = []
    var x = 0
    while (x < 10) {
        Pts[k].add([x, 10 * Chi2.pdf(x, k)])
        x = x + 0.01
    }
}

class Main {
    construct new() {
        Window.title = "Chi-squared distribution for k in [0, 4]"
        Canvas.resize(1000, 600)
        Window.resize(1000, 600)
        Canvas.cls(Color.white)
        var axes = Axes.new(100, 500, 800, 400, -0.5..10, -0.5..5)
        axes.draw(Color.black, 2)
        var xMarks = 0..10
        var yMarks = 0..5
        axes.mark(xMarks, yMarks, Color.black, 2)
        var xMarks2 = Stepped.new(0..10, 2)
        var yMarks2 = 0..5
        axes.label(xMarks2, yMarks2, Color.black, 2, Color.black, 1, 10)
        var colors = [Color.blue, Color.yellow, Color.green, Color.red, Color.purple]
        for (k in 0..4) {
            axes.lineGraph(Pts[k], colors[k], 2)
        }
        axes.rect(8, 5, 120, 110, Color.black)
        for (k in 0..4) {
            var y = 4.75 - k * 0.25
            axes.line(8.2, y, 9, y, colors[k], 2)
            y = 385 - k * 18
            axes.print(750, y, k.toString, Color.black)
        }
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
