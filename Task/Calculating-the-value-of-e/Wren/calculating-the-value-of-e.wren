var epsilon = 1e-15
var fact = 1
var e = 2
var n = 2
while (true) {
    var e0 = e
    fact = fact * n
    n = n + 1
    e = e + 1/fact
    if ((e - e0).abs < epsilon) break
}
System.print("e = %(e)")
