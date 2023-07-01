import "/fmt" for Fmt
import "/iterate" for Stepped

var euler = Fn.new { |f, y, step, end|
    Fmt.write(" Step $2d: ", step)
    for (t in Stepped.new(0..end, step)) {
        if (t%10 == 0) Fmt.write(" $7.3f", y)
        y = y + step * f.call(y)
    }
    System.print()
}

var analytic = Fn.new {
    System.write("    Time: ")
    for (t in Stepped.new(0..100, 10)) Fmt.write(" $7d", t)
    System.write("\nAnalytic: ")
    for (t in Stepped.new(0..100, 10)) {
        Fmt.write(" $7.3f", 20 + 80 * (-0.07*t).exp)
    }
    System.print()
}
var cooling = Fn.new { |temp| -0.07 * (temp - 20) }

analytic.call()
for (i in [2, 5, 10]) euler.call(cooling, 100, i, 100)
