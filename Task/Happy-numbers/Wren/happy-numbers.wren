var happy = Fn.new { |n|
    var m = {}
    while (n > 1) {
        m[n] = true
        var x = n
        n = 0
        while (x > 0) {
            var d = x % 10
            n = n + d*d
            x = (x/10).floor
        }
        if (m[n] == true) return false // m[n] will be null if 'n' is not a key
    }
    return true
}

var found = 0
var n = 1
while (found < 8) {
    if (happy.call(n)) {
        System.write("%(n) ")
        found = found + 1
    }
    n = n + 1
}
System.print()
