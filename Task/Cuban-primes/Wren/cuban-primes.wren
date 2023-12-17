import "./fmt" for Fmt

var start = System.clock
var primes = [3, 5]
var cutOff = 200
var bigOne = 100000
var cubans = []
var bigCuban = ""
var c = 0
var showEach = true
var u = 0
var v = 1

for (i in 1...(1<<20)) {
    var found = false
    u = u + 6
    v = v + u
    var mx = v.sqrt.floor
    for (item in primes) {
        if (item > mx) break
        if (v%item == 0) {
            found = true
            break
        }
    }
    if (!found) {
        c = c + 1
        if (showEach) {
            var z = primes[-1]
            while (z <= v -2) {
                z = z + 2
                var fnd = false
                for (item in primes) {
                    if (item > mx) break
                    if (z%item == 0) {
                        fnd = true
                        break
                    }
                }
                if (!fnd) {
                    primes.add(z)
                }
            }
            primes.add(v)
            cubans.add(Fmt.commatize(v))
            if (c == cutOff) showEach = false
        }
        if (c == bigOne) {
            bigCuban = Fmt.commatize(v)
            break
        }
    }
}

System.print("The first 200 cuban primes are:-")
for (i in 0...20) {
    var j = i * 10
    for (k in j...j+10) System.write(Fmt.s(10, cubans[k])) // 10 per line say
    System.print()
}

System.print("\nThe 100,000th cuban prime is %(bigCuban)")
System.print("\nTook %(System.clock - start) secs")
