import "/fmt" for Fmt

var rungeKutta4 = Fn.new { |t0, tz, dt, y, yd|
    var tn = t0
    var yn = y.call(tn)
    var z = ((tz - t0)/dt).truncate
    for (i in 0..z) {
        if (i % 10 == 0) {
            var exact = y.call(tn)
            var error = yn - exact
            Fmt.print("$4.1f  $10f  $10f  $9f", tn, yn, exact, error)
        }
        if (i == z) break
        var dy1 = dt * yd.call(tn, yn)
        var dy2 = dt * yd.call(tn + 0.5 * dt, yn + 0.5 * dy1)
        var dy3 = dt * yd.call(tn + 0.5 * dt, yn + 0.5 * dy2)
        var dy4 = dt * yd.call(tn + dt, yn + dy3)
        yn = yn + (dy1 + 2.0 * dy2 + 2.0 * dy3 + dy4) / 6.0
        tn = tn + dt
    }
}

System.print("  T        RK4        Exact      Error")
System.print("----  ---------  ----------  ---------")
var y = Fn.new { |t|
    var x = t * t + 4.0
    return x * x / 16.0
}
var yd = Fn.new { |t, yt| t * yt.sqrt }
rungeKutta4.call(0, 10, 0.1, y, yd)
