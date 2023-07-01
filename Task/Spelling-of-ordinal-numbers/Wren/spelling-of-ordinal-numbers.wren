var small = ["zero", "one", "two", "three", "four", "five", "six",  "seven", "eight", "nine", "ten", "eleven",
             "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]

var tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

var illions = ["", " thousand", " million", " billion"," trillion", " quadrillion", " quintillion"]

var irregularOrdinals = {
    "one":    "first",
    "two":    "second",
    "three":  "third",
    "five":   "fifth",
    "eight":  "eighth",
    "nine":   "ninth",
    "twelve": "twelfth"
}

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
        System.write("") // guards against VM recursion bug
        if (s > 0) t = t + " " + say.call(s)
    } else {
        var sx = ""
        var i = 0
        while (n > 0) {
            var p = n % 1000
            n = (n/1000).floor
            if (p > 0) {
                System.write("") // guards against VM recursion bug
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

var sayOrdinal = Fn.new { |n|
    var s = say.call(n)
    var r = s[-1..0]
    var i1 = r.indexOf(" ")
    if (i1 != -1) i1 = s.count - 1 - i1
    var i2 = r.indexOf("-")
    if (i2 != -1) i2 = s.count - 1 - i2
    var i = (i1 > i2) ? i1 : i2
    i = i + 1
    // Now s[0...i] is everything up to and including the space or hyphen
	// and s[i..-1] is the last word; we modify s[i..-1] as required.
	// Since indexOf returns -1 if there was no space/hyphen,
	// `i` will be zero and this will still be fine.
    var x = irregularOrdinals[s[i..-1]]
    if (x) {
        return s[0...i] + x
    } else if (s[-1] == "y") {
        return s[0...i] + s[i..-2] + "ieth"
    } else {
        return s[0...i] + s[i..-1] + "th"
    }
}

for (n in [1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 9007199254740991]) {
    System.print(sayOrdinal.call(n))
}
