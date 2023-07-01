var f = Fn.new { |g, n|
    for (i in 1..n) g.call(n)
}

var g = Fn.new { |k|
    for (i in 1..k) System.write("%(i) ")
    System.print()
}

f.call(g, 5)
