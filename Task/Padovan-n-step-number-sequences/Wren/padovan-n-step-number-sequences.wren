import "/fmt" for Fmt

var padovanN // recursive
padovanN = Fn.new { |n, t|
    if (n < 2 || t < 3) return [1] * t
    var p = padovanN.call(n-1, t)
    if (n + 1 >= t) return p
    for (i in n+1...t) {
        p[i] = 0
        for (j in i-2..i-n-1) p[i] = p[i] + p[j]
    }
    return p
}

var t = 15
System.print("First %(t) terms of the Padovan n-step number sequences:")
for (n in 2..8) Fmt.print("$d: $3d" , n, padovanN.call(n, t))
