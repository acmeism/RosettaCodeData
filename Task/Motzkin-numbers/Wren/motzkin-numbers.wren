import "/long" for ULong
import "/fmt" for Fmt

var motzkin = Fn.new { |n|
    var m = List.filled(n+1, 0)
    m[0] = ULong.one
    m[1] = ULong.one
    for (i in 2..n) {
        m[i] = (m[i-1] * (2*i + 1) + m[i-2] * (3*i -3))/(i + 2)
    }
    return m
}

System.print(" n          M[n]             Prime?")
System.print("-----------------------------------")
var m = motzkin.call(41)
for (i in 0..41) {
    Fmt.print("$2d  $,23i  $s", i, m[i], m[i].isPrime)
}
