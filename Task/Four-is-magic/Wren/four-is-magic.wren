import "./str" for Str

var small = ["zero", "one", "two", "three", "four", "five", "six",  "seven", "eight", "nine", "ten", "eleven",
             "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]

var tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

var illions = ["", " thousand", " million", " billion"," trillion", " quadrillion", " quintillion"]

var say
say = Fn.new { |n|
    var t = ""
    if (n < 0) {
        t = "negative "
        n = -n
    }
    if (n < 20) {
        t = t + small[n]
    } else if (n < 100) {
        t = t + tens[(n/10).floor]
        var s = n % 10
        if (s > 0) t = t + "-" + small[s]
    } else if (n < 1000) {
        t = t + small[(n/100).floor] + " hundred"
        var s = n % 100
        if (s > 0) t = t + " " + say.call(s)
    } else {
        var sx = ""
        var i = 0
        while (n > 0) {
            var p = n % 1000
            n = (n/1000).floor
            if (p > 0) {
                var ix = say.call(p) + illions[i]
                if (sx != "") ix = ix + " " + sx
                sx = ix
            }
            i = i + 1
        }
        t = t + sx
    }
    return t
}

var fourIsMagic = Fn.new { |n|
    var s = Str.capitalize(say.call(n))
    var t = s
    while (n != 4) {
        n = s.count
        s = say.call(n)
        t = t + " is " + s + ", " + s
    }
    return t + " is magic."
}

for (n in [0, 4, 6, 11, 13, 75, 100, 337, -164,  9007199254740991]) {
    System.print(fourIsMagic.call(n))
}
