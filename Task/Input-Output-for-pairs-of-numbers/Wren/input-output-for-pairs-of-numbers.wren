import "io" for Stdin

var output = Fn.new { |pairs| pairs.each { |p| System.print(p[0] + p[1]) } }

var n = Num.fromString(Stdin.readLine())
if (!n || !n.isInteger || n < 1) Fiber.abort("Number of pairs must be a positive integer.")
var pairs = []
for (i in 0...n) {
    var line = Stdin.readLine()
    var sp = line.split(" ")
    if (sp.count != 2) Fiber.abort("Each line must contain 2 integers, separated by a space.")
    var p1 = Num.fromString(sp[0])
    if (!p1 || !p1.isInteger) Fiber.abort("First value is not an integer.")
    var p2 = Num.fromString(sp[1])
    if (!p2 || !p2.isInteger) Fiber.abort("Second value is not an integer.")
    pairs.add([p1, p2])
}
System.print()
output.call(pairs)
