import "./big" for BigRat
import "./fmt" for Fmt

var toEngel = Fn.new { |x|
    var engel = []
    var u = BigRat.fromDecimal(x)
    while (true) {
        var a = u.inverse.ceil
        engel.add(a.toBigInt)
        u = u * a - BigRat.one
        if (u == 0) return engel
    }
}

var fromEngel = Fn.new { |engel|
    var sum = BigRat.zero
    var prod = BigRat.one
    for (e in engel) {
        var r = BigRat.new(e).inverse
        prod = prod * r
        sum = sum + prod
    }
    return sum
}

var rats = [
    "3.14159265358979", "2.71828182845904", "1.414213562373095", "7.59375",
    "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211",
    "2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743",
    "1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558",
    "25.628906"
]
for (rat in rats) {
    Fmt.print("Rational number : $s", rat)
    var dix = rat.indexOf(".") + 1
    var places = rat.count - dix
    var engel = toEngel.call(rat)
    Fmt.print("Engel expansion : $i", engel.take(30).toList)
    Fmt.print("Number of terms : $d", engel.count)
    Fmt.print("Back to rational: $s\n", fromEngel.call(engel.take(70).toList).toDecimal(places))
}
