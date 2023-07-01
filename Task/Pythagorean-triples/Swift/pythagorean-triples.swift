var total = 0
var prim = 0
var maxPeri = 100

func newTri(s0:Int, _ s1:Int, _ s2: Int) -> () {

    let p = s0 + s1 + s2
    if p <= maxPeri {
        prim += 1
        total += maxPeri / p
        newTri( s0 + 2*(-s1+s2), 2*( s0+s2) - s1, 2*( s0-s1+s2) + s2)
        newTri( s0 + 2*( s1+s2), 2*( s0+s2) + s1, 2*( s0+s1+s2) + s2)
        newTri(-s0 + 2*( s1+s2), 2*(-s0+s2) + s1, 2*(-s0+s1+s2) + s2)
    }
}

while maxPeri <= 100_000_000 {
    prim = 0
    total = 0
    newTri(3, 4, 5)
    print("Up to \(maxPeri) : \(total) triples \( prim) primitives.")
    maxPeri *= 10
}
