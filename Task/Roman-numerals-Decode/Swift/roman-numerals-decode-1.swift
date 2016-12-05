func rtoa(var str: String) -> Int {

    var result = 0

    for (value, letter) in
       [( 1000,    "M"),
        (  900,   "CM"),
        (  500,    "D"),
        (  400,   "CD"),
        (  100,    "C"),
        (   90,   "XC"),
        (   50,    "L"),
        (   40,   "XL"),
        (   10,    "X"),
        (    9,   "IX"),
        (    5,    "V"),
        (    4,   "IV"),
        (    1,    "I")]
    {
        while str.hasPrefix(letter) {
            result += value
            str = str[advance(str.startIndex, count(letter)) ..< str.endIndex]
        }
    }
    return result
}

println(rtoa("MDCLXVI")) // 1666
