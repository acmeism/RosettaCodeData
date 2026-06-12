var colors = ["grey", "yellow", "green"]

var wordle = Fn.new { |answer, guess|
    var n = guess.count
    if (answer.count != n) Fiber.abort("The words must be of the same length.")
    answer = answer.toList
    var result = List.filled(n, 0)
    for (i in 0...n) {
        if (guess[i] == answer[i]) {
            answer[i] = "\0"
            result[i] = 2
        }
    }
    for (i in 0...n) {
        var ix = answer.indexOf(guess[i])
        if (ix >= 0) {
            answer[ix] = "\0"
            result[i] = 1
        }
    }
    return result
}

var pairs = [
    ["ALLOW", "LOLLY"],
    ["BULLY", "LOLLY"],
    ["ROBIN", "ALERT"],
    ["ROBIN", "SONIC"],
    ["ROBIN", "ROBIN"]
]
for (pair in pairs) {
    var res  = wordle.call(pair[0], pair[1])
    var res2 = res.map { |i| colors[i] }.toList
    System.print("%(pair[0]) v %(pair[1]) => %(res) => %(res2)")
}
