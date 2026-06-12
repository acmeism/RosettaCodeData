import "./sort" for Find
import "./fmt" for Fmt

var klarnerRado = Fn.new { |limit|
    var kr = [1]
    for (i in 0...limit) {
        var n = kr[i]
        for (e in [2*n + 1, 3*n + 1]) {
            if (e > kr[-1]) {
                kr.add(e)
            } else {
                var ix = Find.nearest(kr, e)  // binary search
                if (kr[ix] != e) kr.insert(ix, e)
            }
        }
    }
    return kr[0...limit]
}

var kr = klarnerRado.call(1e6)
System.print("First 100 elements of Klarner-Rado sequence:")
Fmt.tprint("$3d ", kr[0..99], 10)
System.print()
var limits = [1, 10, 1e2, 1e3, 1e4, 1e5, 1e6]
for (limit in limits) {
    Fmt.print("The $,r element: $,d", limit, kr[limit-1])
}
