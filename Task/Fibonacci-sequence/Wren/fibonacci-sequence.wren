// iterative (quick)
var fibItr = Fn.new { |n|
    if (n < 2) return n
    var a = 0
    var b = 1
    for (i in 2..n) {
        var c = a + b
        a = b
        b = c
    }
    return b
}

// recursive (slow)
var fibRec
fibRec = Fn.new { |n|
    if (n < 2) return n
    return fibRec.call(n-1) + fibRec.call(n-2)
}

System.print("Iterative: %(fibItr.call(36))")
System.print("Recursive: %(fibRec.call(36))")
