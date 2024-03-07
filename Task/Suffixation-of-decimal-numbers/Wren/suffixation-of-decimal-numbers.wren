import "./big" for BigRat
import "./fmt" for Fmt

var suffixes = " KMGTPEZYXWVU"
var googol = BigRat.fromDecimal("1e100")

var suffize = Fn.new { |arg|
    var fields = arg.split(" ").where { |s| s != "" }.toList
    if (fields.isEmpty) fields.add("0")
    var a = fields[0]
    var places
    var base
    var frac  = ""
    var radix = ""
    var fc = fields.count
    if (fc == 1) {
        places = -1
        base = 10
    } else if (fc == 2) {
        places = Num.fromString(fields[1])
        base = 10
        frac = places.toString
    } else if (fc == 3) {
        if (fields[1] == ",") {
            places = 0
            frac = ","
        } else {
            places = Num.fromString(fields[1])
            frac = places.toString
        }
        base = Num.fromString(fields[2])
        if (base !=2 && base != 10) base = 10
        radix = base.toString
    }
    a = a.replace(",", "") // get rid of any commas
    var sign = ""
    if (a[0] == "+" || a[0] == "-") {
        sign = a[0]
        a = a[1..-1] // remove any sign after storing it
    }
    var b = BigRat.fromDecimal(a)
    var g = b >= googol
    var d = (!g && base ==  2) ? BigRat.new(1024, 1) :
            (!g && base == 10) ? BigRat.new(1000, 1) : googol.copy()
    var c = 0
    while (b >= d && c < 12) { // allow b >= 1K if c would otherwise exceed 12
        b = b / d
        c = c + 1
    }
    var suffix = !g ? suffixes[c] : "googol"
    if (base == 2) suffix = suffix + "i"
    System.print("   input number = %(fields[0])")
    System.print("  fraction digs = %(frac)")
    System.print("specified radix = %(radix)")
    System.write("     new number = ")
    BigRat.showAsInt = true
    if (places >= 0) {
        Fmt.print("$0s$s$s", sign, b.toDecimal(places), suffix)
    } else {
        Fmt.print("$0s$s$s", sign, b.toDecimal, suffix)
    }
    System.print()
}

var tests = [
    "87,654,321",
    "-998,877,665,544,332,211,000      3",
    "+112,233                          0",
    "16,777,216                        1",
    "456,789,100,000,000",
    "456,789,100,000,000               2      10",
    "456,789,100,000,000               5       2",
    "456,789,100,000.000e+00           0      10",
    "+16777216                         ,       2",
    "1.2e101",
    "446,835,273,728                   1",
    "1e36",
    "1e39", // there isn't a big enough suffix for this one but it's less than googol
]
for (test in tests) suffize.call(test)
