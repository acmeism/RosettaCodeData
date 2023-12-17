import "./fmt" for Fmt

var fibN = Fn.new { |initial, numTerms|
    var n = initial.count
    if (n < 2 || numTerms < 0) Fiber.abort("Invalid argument(s).")
    if (numTerms <= n) return initial.toList
    var fibs = List.filled(numTerms, 0)
    for (i in 0...n) fibs[i] = initial[i]
    for (i in n...numTerms) {
        var sum = 0
        for (j in i-n...i) sum = sum + fibs[j]
        fibs[i] = sum
    }
    return fibs
}

var names = [
    "fibonacci",  "tribonacci", "tetranacci", "pentanacci", "hexanacci",
    "heptanacci", "octonacci",  "nonanacci",  "decanacci"
]
var initial = [1, 1, 2, 4, 8, 16, 32, 64, 128, 256]
System.print(" n  name         values")
var values = fibN.call([2, 1], 15)
Fmt.write("$2d  $-10s", 2, "lucas")
Fmt.aprint(values, 4, 0, "")
for (i in 0..8) {
    values = fibN.call(initial[0...i + 2], 15)
    Fmt.write("$2d  $-10s", i + 2, names[i])
    Fmt.aprint(values, 4, 0, "")
}
