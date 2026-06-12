import "./math" for Nums

var hourglassFlipper = Fn.new { |hourglasses, target|
    var flippers = hourglasses.toList
    var series = []
    for (iter in 0...10000) {
        var n = Nums.min(flippers)
        series.add(n)
        for (i in 0...flippers.count) flippers[i] = flippers[i] - n
        var i = 0
        for (flipper in flippers) {
            if (flipper == 0) flippers[i] = hourglasses[i]
            i = i + 1
        }
        for (start in series.count-1..0) {
            if (Nums.sum(series[start..-1]) == target) return [start, series]
        }
    }
    Fiber.abort("Unable to find an answer within 10,000 iterations.")
}

System.write("Flip an hourglass every time it runs out of grains, ")
System.print("and note the interval in time.")
var tests = [ [[4, 7], 9], [[5, 7, 31], 36] ]
for (test in tests) {
    var hourglasses = test[0]
    var target = test[1]
    var res = hourglassFlipper.call(hourglasses, target)
    var start = res[0]
    var series = res[1]
    var end = series.count - 1
    System.print("\nSeries: %(series)")
    System.write("Use hourglasses from indices %(start) to %(end) (inclusive) to sum ")
    System.print("%(target) using %(hourglasses)")
}
