import "./fmt" for Fmt

var NMAX = 3200
var a = List.filled(NMAX, 0)
for (i in 0...NMAX) a[i] = i + 1
for (piv in 2...a.count) {
    var i = 0
    while (i < piv-1 && i < a.count-1) {
        var su = a[i] + a[i+1]
        a.remove(su)
        var j = i + 2
        while (j < piv && j < a.count) {
            su = su + a[j]
            a.remove(su)
            if (su > NMAX) break
            j = j + 1
        }
        i = i + 1
    }
}

System.print("First hundred:")
Fmt.tprint("$3d ", a.take(100), 10)
System.print("\nOne thousandth: %(a[999])")
