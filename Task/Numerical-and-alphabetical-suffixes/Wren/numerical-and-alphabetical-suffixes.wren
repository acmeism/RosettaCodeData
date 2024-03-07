import "./big" for BigRat
import "./str" for Str
import "./fmt" for Fmt

var abbrevs = {
    "PAIRs": [4, 2], "SCOres": [3, 20], "DOZens": [3, 12],
    "GRoss": [2, 144], "GREATGRoss": [7, 1728], "GOOGOLs": [6, 1e100]
}

var metric = {
    "K": 1e3,  "M": 1e6,  "G": 1e9,  "T": 1e12, "P": 1e15, "E": 1e18,
    "Z": 1e21, "Y": 1e24, "X": 1e27, "W": 1e30, "V": 1e33, "U": 1e36
}

var b = Fn.new { |e| BigRat.two.pow(e) }

var binary = {
    "Ki": b.call(10), "Mi": b.call(20),  "Gi": b.call(30),  "Ti": b.call(40),
    "Pi": b.call(50), "Ei": b.call(60),  "Zi": b.call(70),  "Yi": b.call(80),
    "Xi": b.call(90), "Wi": b.call(100), "Vi": b.call(110), "Ui": b.call(120)
}

var googol = BigRat.fromDecimal("1e100")

var fact = Fn.new { |num, d|
    var prod = 1
    var n = Num.fromString(num)
    var i = n
    while (i > 0) {
        prod = prod * i
        i = i - d
    }
    return prod
}

var parse = Fn.new { |number|
    // find index of last digit
    var i = number.count - 1
    while (i >= 0) {
        if (48 <= number.bytes[i] && number.bytes[i] <= 57) break
        i = i - 1
    }
    var num = number[0..i]
    num = num.replace(",", "") // get rid of any commas
    var suf = Str.upper(number[i+1..-1])
    if (suf == "") return BigRat.fromDecimal(num)
    if (suf[0] == "!") {
        var prod = fact.call(num, suf.count)
        return BigRat.new(prod)
    }
    for (me in abbrevs) {
        var kk = Str.upper(me.key)
        if (kk.startsWith(suf) && suf.count >= me.value[0]) {
            var t1 = BigRat.fromDecimal(num)
            var t2 = (me.key != "GOOGOLS") ? BigRat.fromDecimal(me.value[1]) : googol
            return t1 * t2
        }
    }
    var bf = BigRat.fromDecimal(num)
    for (me in metric) {
        var j = 0
        while (j < suf.count) {
            if (me.key == suf[j]) {
                if (j < suf.count-1 && suf[j+1] == "I") {
                    bf = bf * binary[me.key + "i"]
                    j = j + 1
                } else {
                    bf = bf * me.value
                }
            }
            j = j + 1
        }
    }
    return bf
}

var process = Fn.new { |numbers|
    System.write("numbers =  ")
    for (number in numbers) Fmt.write("$s   ", number)
    System.write("\nresults =  ")
    for (number in numbers) {
        var res = parse.call(number)
        if (res.isInteger) {
            Fmt.write("$,s  ", res.toDecimal(50))
        } else {
            var sres = Fmt.swrite("$,s", res.truncate.toDecimal)
            Fmt.write("$s  ", sres + res.fraction.abs.toDecimal(50)[1..-1])
        }
    }
    System.print("\n")
}

var numbers = ["2greatGRo", "24Gros", "288Doz", "1,728pairs", "172.8SCOre"]
process.call(numbers)

numbers = ["1,567", "+1.567k", "0.1567e-2m"]
process.call(numbers)

numbers = ["25.123kK", "25.123m", "2.5123e-00002G"]
process.call(numbers)

numbers = ["25.123kiKI", "25.123Mi", "2.5123e-00002Gi", "+.25123E-7Ei"]
process.call(numbers)

numbers = ["-.25123e-34Vikki", "2e-77gooGols"]
process.call(numbers)

numbers = ["9!", "9!!", "9!!!", "9!!!!", "9!!!!!", "9!!!!!!", "9!!!!!!!", "9!!!!!!!!", "9!!!!!!!!!"]
process.call(numbers)
