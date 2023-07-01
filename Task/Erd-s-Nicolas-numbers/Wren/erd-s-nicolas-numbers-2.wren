import "./fmt" for Fmt

var maxNum = 1e8
var dsum = List.filled(maxNum+1,1)
var dcount = List.filled(maxNum+1, 1)
for (i in 2..maxNum) {
    var j = i + i
    while (j <= maxNum) {
        if (dsum[j] == j) {
            Fmt.print("$8d equals the sum of its first $d divisors", j, dcount[j])
        }
        dsum[j] = dsum[j] + i
        dcount[j] = dcount[j] + 1
        j = j + i
    }
}
