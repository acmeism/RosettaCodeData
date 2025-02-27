import "./fmt" for Fmt

var decode = Fn.new { |r|
    if (r == "") return 0
    var n = 0
    var last = "0"
    for (c in r) {
        var k
        if (c == "I") {
            k = 1
        } else if (c == "V") {
            k = (last == "I") ? 3 : 5
        } else if (c == "X") {
            k = (last == "I") ? 8 : 10
        } else if (c == "L") {
            k = (last == "X") ? 30 : 50
        } else if (c == "C") {
            k = (last == "X") ? 80 : 100
        } else if (c == "D") {
            k = (last == "C") ? 300 : 500
        } else if (c == "M") {
            k = (last == "C") ? 800 : 1000
        }
        n = n + k
        last = c
    }
    return n
}

var romans = ["I", "III", "IV", "VIII", "XLIX", "CCII", "CDXXXIII", "MCMXC", "MMVIII", "MDCLXVI"]
for (r in romans) System.print("%(Fmt.s(-10, r)) = %(decode.call(r))")
