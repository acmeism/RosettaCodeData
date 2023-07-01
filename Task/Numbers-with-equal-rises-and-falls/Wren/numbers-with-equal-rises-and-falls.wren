import "/fmt" for Fmt

var risesEqualsFalls = Fn.new { |n|
    if (n < 10) return true
    var rises = 0
    var falls = 0
    var prev = -1
    while (n > 0) {
        var d = n%10
        if (prev >= 0) {
            if (d < prev) {
                rises = rises + 1
            } else if (d > prev) {
                falls = falls + 1
            }
        }
        prev = d
        n = (n/10).floor
    }
    return rises == falls
}

System.print("The first 200 numbers in the sequence are:")
var count = 0
var n = 1
while (true) {
    if (risesEqualsFalls.call(n)) {
        count = count + 1
        if (count <= 200) {
            Fmt.write("$3d ", n)
            if (count % 20 == 0) System.print()
        }
        if (count == 1e7) {
            Fmt.print("\nThe 10 millionth number in the sequence is $,d.", n)
            break
        }
    }
    n = n + 1
}
