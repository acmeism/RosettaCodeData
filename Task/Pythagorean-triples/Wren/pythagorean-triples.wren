var sc = System.clock
var total = 0
var prim = 0
var maxPeri = 0

var newTri // recursive function so needs to be declared before it can be called
newTri = Fn.new { |s0, s1, s2|
    var p = s0 + s1 + s2
    if (p <= maxPeri) {
        prim = prim + 1
        total = total + (maxPeri/p).floor
        newTri.call( 1*s0-2*s1+2*s2,  2*s0-1*s1+2*s2,  2*s0-2*s1+3*s2)
        newTri.call( 1*s0+2*s1+2*s2,  2*s0+1*s1+2*s2,  2*s0+2*s1+3*s2)
        newTri.call(-1*s0+2*s1+2*s2, -2*s0+1*s1+2*s2, -2*s0+2*s1+3*s2)
    }
}

maxPeri = 100
while (maxPeri <= 1e10) {
    prim = 0
    total = 0
    newTri.call(3, 4, 5)
    var secs = (System.clock - sc).round
    System.print("Up to %(maxPeri):  %(total) triples, %(prim) primitives, %(secs) seconds")
    maxPeri = 10 * maxPeri
}
