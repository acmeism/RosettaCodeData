import "./fmt" for Fmt

var prevRow = []
var max = 15

for (n in 0...max) {
    var row = []
    for (k in 0..n) {
        if (k == 0) {
            row.add(1)
        } else if (k < n) {
            row.add(prevRow[k] + prevRow[k - 1])
        } else {
            row.add(1 << n)
        }
    }
    Fmt.tprint("$-5d", row, row.count)
    prevRow = row
}
