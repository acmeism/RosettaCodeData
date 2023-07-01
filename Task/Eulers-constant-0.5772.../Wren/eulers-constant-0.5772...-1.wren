import "./fmt" for Fmt

var eps = 1e-6

System.print("From the definition, err. 3e-10")
var n = 400
var h = 1
for (k in 2..n) h = h + 1/k
//faster convergence: Negoi, 1997
var a = (n + 0.5 + 1/(24*n)).log

Fmt.print("Hn    $0.14f", h)
Fmt.print("gamma $0.14f\nk = $d\n", h - a, n)

System.print("Sweeney, 1963, err. idem")
n = 21
var s = [0, n]
var r = n
var k = 1
while (true) {
    k = k + 1
    r = r * n / k
    s[k & 1] = s[k & 1] + r/k
    if (r <= eps) break
}
Fmt.print("gamma $0.14f\nk = $d\n", s[1] - s[0] - n.log, k)

System.print("Bailey, 1988")
n = 5
a = 1
h = 1
var n2 = 2.pow(n)
r = 1
k = 1
while (true) {
    k = k + 1
    r = r * n2 / k
    h = h + 1/k
    var b = a
    a = a + r * h
    if ((b-a).abs <= eps) break
}
a = a * n2 / n2.exp
Fmt.print("gamma $0.14f\nk = $d\n", a - n * 2.log, k)

System.print("Brent-McMillan, 1980")
n = 13
a = -n.log
var b = 1
var u = a
var v = b
n2 = n * n
var k2 = 0
k = 0
while (true) {
    k2 = k2 + 2*k + 1
    k = k + 1
    a = a * n2 / k
    b = b * n2 / k2
    a = (a + b)/k
    u = u + a
    v = v + b
    if (a.abs <= eps) break
}
Fmt.print("gamma $0.14f\nk = $d\n", u / v, k)

System.print("How Euler did it in 1735")
// Bernoulli numbers with even indices
var b2 = [1, 1/6, -1/30, 1/42, -1/30, 5/66, -691/2730, 7/6, -3617/510, 43867/798]
var m = 7
n = 10
// n'th harmonic number
h = 1
for (k in 2..n) h = h + 1/k
Fmt.print("Hn    $0.14f", h)
h = h - n.log
Fmt.print("  -ln $0.14f", h)
// expansion C = -digamma(1)
a = -1 / (2*n)
n2 = n * n
r = 1
for (k in 1..m) {
    r = r * n2
    a = a + b2[k] / (2*k*r)
}
Fmt.print("err  $0.14f\ngamma $0.14f\nk = $d", a, h + a, n + m)
System.print("\nC = 0.57721566490153286...")
