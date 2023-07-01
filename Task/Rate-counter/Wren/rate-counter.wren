var cube = Fn.new { |n| n * n * n }

var benchmark = Fn.new { |n, func, arg, calls|
    var times = List.filled(n, 0)
    for (i in 0...n) {
        var m = System.clock
        for (j in 0...calls) func.call(arg)
        times[i] = ((System.clock - m) * 1000).round  // milliseconds
    }
    return times
}

System.print("Timings (milliseconds) : ")
for (time in benchmark.call(10, cube, 5, 1e6)) System.print(time)
