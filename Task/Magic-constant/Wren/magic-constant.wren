import "./seq" for Lst
import "./fmt" for Fmt

var magicConstant = Fn.new { |n| (n*n + 1) * n / 2 }

var ss = ["\u2070", "\u00b9", "\u00b2", "\u00b3", "\u2074",
          "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"]

var superscript = Fn.new { |n| (n < 10) ? ss[n] : (n < 20) ? ss[1] + ss[n - 10] : ss[2] + ss[0] }

System.print("First 20 magic constants:")
var mc20 = (3..22).map { |n| magicConstant.call(n) }.toList
for (chunk in Lst.chunks(mc20, 10)) Fmt.print("$5d", chunk)

Fmt.print("\n1,000th magic constant: $,d", magicConstant.call(1002))

System.print("\nSmallest order magic square with a constant greater than:")
for (i in 1..20) {
    var goal = 10.pow(i)
    var order = (goal * 2).cbrt.floor + 1
    Fmt.print("10$-2s : $,9d", superscript.call(i), order)
}
