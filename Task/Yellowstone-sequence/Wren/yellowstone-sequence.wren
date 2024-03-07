import "./math" for Int

var yellowstone = Fn.new { |n|
    var m = {}
    var a = List.filled(n + 1, 0)
    for (i in 1..3) {
        a[i] = i
        m[i] = true
    }
    var min = 4
    for (c in 4..n) {
        var i = min
        while (true) {
            if (!m[i] && Int.gcd(a[c-1], i) == 1 && Int.gcd(a[c-2], i) > 1) {
                a[c] = i
                m[i] = true
                if (i == min) min = min + 1
                break
            }
            i = i + 1
        }
    }
    return a[1..-1]
}

var x = List.filled(30, 0)
for (i in 0...30) x[i] = i + 1
var y = yellowstone.call(30)
System.print("The first 30 Yellowstone numbers are:")
System.print(y)
