import "./fmt" for Fmt

var prod = 1
var sum = 0
var x = 5
var y = -5
var z = -2
var one = 1
var three = 3
var seven = 7
var p = 11.pow(x)
var j = 0

var process = Fn.new {
    sum = sum + j.abs
    if (prod.abs < (1 << 27) && j != 0) prod = prod * j
}

j = -three
while (j <= 3.pow(3)) {
    process.call()
    j = j + three
}

j = -seven
while (j <= seven) {
    process.call()
    j = j + x
}

j = 555
while (j <= 550 - y) {
    process.call()
    j = j + 1
}

j = 22
while (j >= -28) {
    process.call()
    j = j - three
}

j = 1927
while (j <= 1939) {
    process.call()
    j = j + 1
}

j = x
while (j >= y) {
    process.call()
    j = j - (-z)
}

j = p
while (j <= p + one) {
    process.call()
    j = j + 1
}

Fmt.print("sum  =  $,d", sum)
Fmt.print("prod = $,d", prod)
