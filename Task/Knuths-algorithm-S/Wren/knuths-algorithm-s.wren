import "random" for Random

var r = Random.new()

var sOfNCreator = Fn.new { |n|
    var s = List.filled(n, 0)
    var next = 0
    var m = n
    return Fn.new { |item|
        if (next < n) {
            s[next] = item
            next = next + 1
        } else {
            m = m + 1
            if (r.int(m) < n) {
                var t = r.int(n)
                s[t] = item
                if (next <= t) next = t + 1
            }
        }
        return s
    }
}

var freq = List.filled(10, 0)
for (r in 0...1e5) {
    var sOfN = sOfNCreator.call(3)
    for (d in 48...57) sOfN.call(d)
    for (d in sOfN.call(57)) {
        freq[d - 48] = freq[d - 48] + 1
    }
}
System.print(freq)
