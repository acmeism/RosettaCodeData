// in place left shift by 1
var lshift = Fn.new { |l|
    var n = l.count
    if (n < 2) return
    var f = l[0]
    for (i in 0..n-2) l[i] = l[i+1]
    l[-1] = f
}

var l = (1..9).toList
System.print("Original list     : %(l)")
for (i in 1..3) lshift.call(l)
System.print("Shifted left by 3 : %(l)")
