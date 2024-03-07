import "./sort" for Sort
import "./fmt" for Fmt

var cubesSum = {}
var taxicabs = []

for (i in 1..1199) {
    for (j in i+1..1200) {
        var sum = i*i*i + j*j*j
        if (!cubesSum[sum]) {
            cubesSum[sum] = [i, j]
        } else {
            taxicabs.add([sum, cubesSum[sum], [i, j]])
        }
    }
}
var cmp = Fn.new { |a, b| (a[0] - b[0]).sign }
Sort.quick(taxicabs, 0, taxicabs.count-1, cmp)
// remove those numbers which have additional pairs of cubes
for (i in taxicabs.count-2..0) {
    if (taxicabs[i][0] == taxicabs[i+1][0]) taxicabs.removeAt(i+1)
}

System.print("The first 25 taxicab numbers are:")
for (i in 1..25) {
    var t = taxicabs[i-1]
    Fmt.lprint("$2d: $,7d = $2d³ + $2d³ = $2d³ + $2d³", [i, t[0], t[1][0], t[1][1], t[2][0], t[2][1]])
}

System.print("\nThe 2,000th to 2,006th taxicab numbers are:")
for (i in 2000..2006) {
    var t = taxicabs[i-1]
    Fmt.lprint("$,5d: $,13d = $3d³ + $,5d³ = $3d³ + $,5d³", [i, t[0], t[1][0], t[1][1], t[2][0], t[2][1]])
}
