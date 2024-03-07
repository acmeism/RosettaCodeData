import "./big" for BigInt

var p = []
var pd = []

var partDiffDiff = Fn.new { |n| (n&1 == 1) ? (n + 1)/2 : n + 1 }

var partDiff = Fn.new { |n|
    if (n < 2) return 1
    pd[n] = pd[n-1] + partDiffDiff.call(n-1)
    return pd[n]
}

var partitionsP = Fn.new { |n|
    if (n < 2) return
    var psum = BigInt.zero
    for (i in 1..n) {
        var pdi = partDiff.call(i)
        if (pdi > n) break
        var sign = (i-1)%4 < 2 ? 1 : -1
        psum = psum + p[n-pdi] * sign
    }
    p[n] = psum
}

var start = System.clock
var N = 6666
p = List.filled(N+1, null)
pd = List.filled(N+1, 0)
p[0] = BigInt.one
p[1] = BigInt.one
pd[0] = 1
pd[1] = 1
for (n in 2..N) partitionsP.call(n)
System.print("p[%(N)] = %(p[N])")
System.print("Took %(System.clock - start) seconds")
