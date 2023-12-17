import "./fmt" for Fmt

var isPalindrome2 = Fn.new { |n|
    var x = 0
    if (n % 2 == 0) return n == 0
    while (x < n) {
        x = x*2 + (n%2)
        n = (n/2).floor
    }
    return n == x || n == (x/2).floor
}

var reverse3 = Fn.new { |n|
    var x = 0
    while (n != 0) {
        x = x*3 + (n%3)
        n = (n/3).floor
    }
    return x
}

var start

var show = Fn.new { |n|
    Fmt.print("Decimal : $d", n)
    Fmt.print("Binary  : $b", n)
    Fmt.print("Ternary : $t", n)
    Fmt.print("Time    : $0.3f ms\n", (System.clock - start)*1000)
}

var min = Fn.new { |a, b| (a < b) ? a : b }
var max = Fn.new { |a, b| (a > b) ? a : b }

start = System.clock
System.print("The first 6 numbers which are palindromic in both binary and ternary are :\n")
show.call(0)
var cnt = 1
var lo = 0
var hi = 1
var pow2 = 1
var pow3 = 1
while (true) {
    var i = lo
    while (i < hi) {
        var n = (i*3+1)*pow3 + reverse3.call(i)
        if (isPalindrome2.call(n)) {
            show.call(n)
            cnt = cnt + 1
            if (cnt >= 6) return
        }
        i = i + 1
    }
    if (i == pow3) {
        pow3 = pow3 * 3
    } else {
        pow2 = pow2 * 4
    }
    while (true) {
        while (pow2 <= pow3) pow2 = pow2 * 4
        var lo2 = (((pow2/pow3).floor - 1)/3).floor
        var hi2 = (((pow2*2/pow3).floor-1)/3).floor + 1
        var lo3 = (pow3/3).floor
        var hi3 = pow3
        if (lo2 >= hi3) {
            pow3 = pow3 * 3
        } else if (lo3 >= hi2) {
            pow2 = pow2 * 4
        } else {
            lo = max.call(lo2, lo3)
            hi = min.call(hi2, hi3)
            break
        }
    }
}
