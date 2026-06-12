import "io" for Stdin

var output = Fn.new { |lines| System.print(lines.join("\n")) }

var n = Num.fromString(Stdin.readLine())
if (!n || !n.isInteger || n < 1) Fiber.abort("Number of lines must be a positive integer.")
var lines = List.filled(n, "")
for (i in 0...n) lines[i] = Stdin.readLine()
System.print()
output.call(lines)
