import "./fmt" for Fmt

var lempelZivComplexity = Fn.new { |s|
    var n = s.count
    if (n == 0) return [0, ""]
    var complexity = 0
    var pointer = 0
    var subs = ""
    while (pointer < n) {
        complexity = complexity + 1
        var k = 1
        while (pointer + k <= n) {
            var currentSub = s[pointer...pointer + k]
            var searchWindow = s[0...pointer + k - 1]
            if (searchWindow.contains(currentSub)) {
                k = k + 1
            } else {
                subs = subs + currentSub + "."
                pointer = pointer + k
                k = 0
                break
            }
        }
        if (pointer + k >= n) {
            subs = subs + s[pointer..-1]
            break
        }
    }
    return [complexity, subs]
}

var tests = [
    [       "AZSEDRFTGYGUJIJOKB", 16],
    [       "ABCABCABCABCABCABC",  4],
    [ "111011111001111011111001",  6],
    [       "101001010010111110",  5],
    [         "1001111011000010",  6],
    [               "1010101010",  3],
    [         "1010101010101010",  3],
    [   "1001111011000010000010",  7],
    [ "100111101100001000001010",  8],
    [         "0001101001000101",  6],
    [                  "1111111",  2],
    [                     "0001",  2],
    [                      "010",  3],
    [                        "1",  1],
    [                         "",  0],
    [     "01011010001101110010",  7],
    ["ABCDEFGHIJKLMNOPQRSTUVWXYZ",26],
    ["HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!",11]
]

for (test in tests) {
    var res = lempelZivComplexity.call(test[0])
    var error = ""
    if (res[0] != test[1]) error = "***ERROR***"
    Fmt.print("$61s: $2d$s", res[1], res[0], error)
}
