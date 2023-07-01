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

for (n in [12, 1048576, 9e18, -2, 0]) System.print(say.call(n))
