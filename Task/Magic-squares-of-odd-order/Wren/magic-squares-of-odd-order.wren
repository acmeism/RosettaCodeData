import "./fmt" for Fmt

var ms = Fn.new { |n|
    var M = Fn.new { |x| (x + n - 1) % n }
    if (n <= 0 || n&1 == 0) {
        n = 5
        System.print("forcing size %(n)")
    }
    var m = List.filled(n * n, 0)
    var i = 0
    var j = (n/2).floor
    for (k in 1..n*n) {
        m[i*n + j] = k
        if (m[M.call(i)*n + M.call(j)] != 0) {
            i = (i + 1) % n
        } else {
            i = M.call(i)
            j = M.call(j)
        }
    }
    return [n, m]
}

var res = ms.call(5)
var n = res[0]
var m = res[1]
for (i in 0...n) {
    for (j in 0...n) Fmt.write("$4d", m[i*n+j])
    System.print()
}
System.print("\nMagic number : %(((n*n + 1)/2).floor * n)")
