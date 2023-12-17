import "./big" for BigRat
import "./fmt" for Fmt

var harmonic = Fn.new { |n| (1..n).reduce(BigRat.zero) { |sum, i| sum + BigRat.one/i } }

BigRat.showAsInt = true
System.print("The first 20 harmonic numbers and the 100th, expressed in rational form, are:")
var numbers = (1..20).toList
numbers.add(100)
for (i in numbers) Fmt.print("$3d : $s", i, harmonic.call(i))

System.print("\nThe first harmonic number to exceed the following integers is:")
var i = 1
var limit = 10
var n = 1
var h = 0
while (true) {
    h = h + 1/n
    if (h > i) {
        Fmt.print("integer = $2d  -> n = $,6d  ->  harmonic number = $9.6f (to 6dp)", i, n, h)
        i = i + 1
        if (i > limit) return
    }
    n = n + 1
}
