import "./math" for Int
import "./fmt" for Fmt

var n = 50
var res = []
var prevSum = 1
var i = 2
while (res.count < n) {
    var currSum = Int.divisorSum(i)
    if (prevSum == currSum) res.add(i-1)
    prevSum = currSum
    i = i + 1
}
Fmt.tprint("$,7d", res, 10)
