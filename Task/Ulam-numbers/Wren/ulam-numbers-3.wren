import "./fmt" for Fmt

var ulam = Fn.new { |n|
    if (n <= 2) return n
    var max = 1352000
    var list = List.filled(max+1, 0)
    list[0] = 1
    list[1] = 2
    var sums = List.filled(max*2+1, 0)
    sums[3] = 1
    var size = 2
    var query
    while (true) {
        query = list[size-1] + 1
        while (true) {
            if (sums[query] == 1) {
                for (i in 0..size-1) {
                    var sum = query + list[i]
                    var t = sums[sum] + 1
                    if (t <= 2) sums[sum] = t
                }
                list[size] = query
                size = size + 1
                break
            }
            query = query + 1
        }
        if (size >= n) break
    }
    return query
}

var start = System.clock
var n = 10
while (true) {
    Fmt.print("The $,r Ulam number is $,d", n, ulam.call(n))
    n = n * 10
    if (n > 100000) break
}
System.print("\nTook %(System.clock - start) seconds.")
