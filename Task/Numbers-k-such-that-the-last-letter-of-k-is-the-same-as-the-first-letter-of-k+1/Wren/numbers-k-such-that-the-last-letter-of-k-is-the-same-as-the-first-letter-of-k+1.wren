import "./fmt" for Name, Fmt
import "./math" for Nums

var i = 0
var c = 0
var nums = []
var lastDigs = List.filled(10, 0)
var labels = (0..9).map { |d| d.toString }.toList
var prev = Name.fromNum(0) // "zero"
var limit = 1000
while (limit <= 1e6) {
    var next = Name.fromNum(i+1)
    if (prev[-1] == next[0]) {
        if (c < 50) nums.add(i)
        var ld = i % 10
        lastDigs[ld] = lastDigs[ld] + 1
        c = c + 1
        if (c == 50) {
            System.print("First 50 numbers:")
            Fmt.tprint("$3d ", nums, 10)
            System.print()
        } else if (c == limit) {
            Fmt.print("The $,r number is $,d.\n", c, i)
            var title = Fmt.swrite("Breakdown by last digit of first $,d numbers", c)
            Nums.barChart(title, 80, labels, lastDigs)
            System.print()
            limit = limit * 10
        }
    }
    prev = next
    i = i + 1
}
