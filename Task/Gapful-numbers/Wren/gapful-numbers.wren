import "./fmt" for Fmt

var starts = [1e2, 1e6, 1e7, 1e9, 7123]
var counts = [30, 15, 15, 10, 25]
for (i in 0...starts.count) {
    var count = 0
    var j = starts[i]
    var pow = 100
    while (true) {
        if (j < pow * 10) break
        pow = pow * 10
    }
    System.print("First %(counts[i]) gapful numbers starting at %(Fmt.dc(0, starts[i]))")
    while (count < counts[i]) {
        var fl = (j/pow).floor*10 + (j % 10)
        if (j%fl == 0) {
            System.write("%(j) ")
            count = count + 1
        }
        j = j + 1
        if (j >= 10*pow) pow = pow * 10
    }
    System.print("\n")
}
