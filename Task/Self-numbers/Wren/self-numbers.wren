var sieve = Fn.new {
    var sv = List.filled(2*1e9+9*9+1, false)
    var n = 0
    var s = [0] * 8
    for (a in 0..1) {
        for (b in 0..9) {
            s[0] = a + b
            for (c in 0..9) {
                s[1] = s[0] + c
                for (d in 0..9) {
                   s[2] = s[1] + d
                   for (e in 0..9) {
                        s[3] = s[2] + e
                        for (f in 0..9) {
                            s[4] = s[3] + f
                            for (g in 0..9) {
                                s[5] = s[4] + g
                                for (h in 0..9) {
                                    s[6] = s[5] + h
                                    for (i in 0..9) {
                                        s[7] = s[6] + i
                                        for (j in 0..9) {
                                           sv[s[7] + j + n] = true
                                           n = n + 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return sv
}

var st = System.clock
var sv = sieve.call()
var count = 0
System.print("The first 50 self numbers are:")
for (i in 0...sv.count) {
    if (!sv[i]) {
        count = count + 1
        if (count <= 50) System.write("%(i) ")
        if (count == 1e8) {
            System.print("\n\nThe 100 millionth self number is %(i)")
            break
        }
    }
}
System.print("Took %(System.clock-st) seconds.")
