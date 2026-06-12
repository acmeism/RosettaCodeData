import "./seq" for Lst

var E = Fn.new { |k, n|
    var s = (0...n).map { |i| i < k ? [1] : [0] }.toList
    var d = n - k
    n = k.max(d)
    k = k.min(d)
    var z = d
    while (z > 0 || k > 1) {
        for (i in 0...k) s[i].addAll(s[-1 - i])
        s = s[0...-k]
        z = z - k
        d = n - k
        n = k.max(d)
        k = k.min(d)
    }
    return Lst.flatten(s)
}

System.print(E.call(5, 13).join())
