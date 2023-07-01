var romans = [
    [1000, "M"],
    [900, "CM"],
    [500,  "D"],
    [400, "CD"],
    [100,  "C"],
    [90,  "XC"],
    [50,   "L"],
    [40,  "XL"],
    [10,   "X"],
    [9,   "IX"],
    [5,    "V"],
    [4,   "IV"],
    [1,    "I"]
]

var encode = Fn.new { |n|
    if (n > 5000 || n < 1) return null
    var res = ""
    for (r in romans) {
        while (n >= r[0]) {
            n = n - r[0]
            res = res + r[1]
        }
    }
    return res
}

System.print(encode.call(1990))
System.print(encode.call(1666))
System.print(encode.call(2008))
System.print(encode.call(2020))
