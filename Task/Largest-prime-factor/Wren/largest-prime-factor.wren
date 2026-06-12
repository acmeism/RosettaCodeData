var largestPrimeFactor = Fn.new { |n|
    if (!n.isInteger || n < 2) return 1
    var inc = [4, 2, 4, 2, 4, 6, 2, 6]
    var max = 1
    while (n%2 == 0) {
       max = 2
       n = (n/2).floor
    }
    while (n%3 == 0) {
        max = 3
        n = (n/3).floor
    }
    while (n%5 == 0) {
        max = 5
        n = (n/5).floor
    }
    var k = 7
    var i = 0
    while (k * k <= n) {
        if (n%k == 0) {
            max = k
            n = (n/k).floor
        } else {
            k = k + inc[i]
            i = (i + 1) % 8
        }
    }
    return (n > 1) ? n : max
}

var  n = 600851475143
System.print("The largest prime factor of %(n) is %(largestPrimeFactor.call(n)).")
