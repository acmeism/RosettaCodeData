import "./str" for Str
import "./fmt" for Fmt

var tests = [
    ["the three truths", "th"],
    ["ababababab", "abab"],
    ["abaabba*bbaba*bbab", "a*b"],
    ["aaaaaaaaaaaaaa", "aa"],
    ["aaaaaaaaaaaaaa", "b"],
]

for (test in tests) {
    var count = Str.occurs(test[0], test[1])
    Fmt.print("$6s occurs $d times in $q.", Fmt.q(test[1]), count, test[0])
}
