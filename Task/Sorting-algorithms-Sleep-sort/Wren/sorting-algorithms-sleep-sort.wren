import "timer" for Timer
import "io" for Stdout
import "os" for Process

var args = Process.arguments
var n = args.count
if (n < 2) Fiber.abort("There must be at least two arguments passed.")
var list = args.map{ |a| Num.fromString(a) }.toList
if (list.any { |i| i == null || !i.isInteger || i < 0 } ) {
    Fiber.abort("All arguments must be non-negative integers.")
}
var max = list.reduce { |acc, i| acc = (i > acc) ? i : acc }
var fibers = List.filled(max+1, null)
System.print("Before: %(list.join(" "))")
for (i in list) {
    var sleepSort = Fiber.new { |i|
        Timer.sleep(1000)
        Fiber.yield(i)
    }
    fibers[i] = sleepSort
}
System.write("After : ")
for (i in 0..max) {
    var fib = fibers[i]
    if (fib) {
        System.write("%(fib.call(i)) ")
        Stdout.flush()
    }
}
System.print()
