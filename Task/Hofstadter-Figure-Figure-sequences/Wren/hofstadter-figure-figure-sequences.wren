var r = [0, 1]
var s = [0, 2]

var ffr = Fn.new { |n|
    while (r.count <= n) {
        var nrk = r.count - 1         // last n for which r[n] is known
        var rNxt = r[nrk] + s[nrk]    // r[nrk+1]
        r.add(rNxt)                   // extend r by one element
        for (sn in r[nrk]+2...rNxt) {
            s.add(sn)                 // extend sequence s up to rNxt
        }
        s.add(rNxt + 1)               // extend sequence s one past rNxt
    }
    return r[n]
}

var ffs = Fn.new { |n|
    while (s.count <= n) ffr.call(r.count)
    return s[n]
}

System.print("The first 10 values of R are:")
for (i in 1..10) System.write(" %(ffr.call(i))")
System.print()
var present = List.filled(1001, false)
for (i in 1..40)  present[ffr.call(i)] = true
for (i in 1..960) present[ffs.call(i)] = true
var allPresent = present.skip(1).all { |i| i == true }
System.print("\nThe first 40 values of ffr plus the first 960 values of ffs")
System.print("includes all integers from 1 to 1000 exactly once is %(allPresent).")
