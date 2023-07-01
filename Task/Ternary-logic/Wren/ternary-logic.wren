var False = -1
var Maybe =  0
var True  =  1
var Chrs  = ["F", "M", "T"]

class Trit {
    construct new(v) {
        if (v != False && v != Maybe && v != True) Fiber.abort("Invalid argument.")
        _v = v
    }

    v { _v }

    ! { Trit.new(-_v) }

    &(other)  { (_v < other.v) ? this : other }

    |(other)  { (_v > other.v) ? this : other }

    >>(other) { (-_v > other.v) ? !this : other }

    ==(other) { Trit.new(_v * other.v) }

    toString { Chrs[_v + 1] }
}

var trits = [Trit.new(True), Trit.new(Maybe), Trit.new(False)]

System.print("not")
System.print("-------")
for (t in trits) System.print(" %(t) | %(!t)")

System.print("\nand | T  M  F")
System.print("-------------")
for (t in trits) {
    System.write(" %(t)  | ")
    for (u in trits) System.write("%(t & u)  ")
    System.print()
}

System.print("\nor  | T  M  F")
System.print("-------------")
for (t in trits) {
    System.write(" %(t)  | ")
    for (u in trits) System.write("%(t | u)  ")
    System.print()
}

System.print("\nimp | T  M  F")
System.print("-------------")
for (t in trits) {
    System.write(" %(t)  | ")
    for (u in trits) System.write("%(t >> u)  ")
    System.print()
}

System.print("\neqv | T  M  F")
System.print("-------------")
for (t in trits) {
    System.write(" %(t)  | ")
    for (u in trits) System.write("%(t == u)  ")
    System.print()
}
