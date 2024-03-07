import "io" for Stdin, Stdout
import "./fmt" for Fmt

var f = Fn.new { |x| x.abs.sqrt + 5*x*x*x }

var s = List.filled(11, 0)
System.print("Please enter 11 numbers:")
var count = 0
while (count < 11) {
    Fmt.write("  Number $-2d : ", count + 1)
    Stdout.flush()
    var number = Num.fromString(Stdin.readLine())
    if (!number) {
        System.print("Not a valid number, try again.")
    } else {
        s[count] = number
        count = count + 1
    }
}
s = s[-1..0]
System.print("\nResults:")
for (item in s) {
    var fi = f.call(item)
    if (fi <= 400) {
        Fmt.print("  f($6.3f) = $7.3f", item, fi)
    } else {
        Fmt.print("  f($6.3f) = overflow", item)
    }
}
