class Variant {
    construct new(v) {
        // restrict 'v' to numbers or strings
        if (v.type != Num && v.type != String) {
            Fiber.abort("Value must be a number or a string.")
        }
        _v = v
    }

    v { _v }

    kind { _v.type }

    toString { v.toString }
}

var v1 = Variant.new(6)
System.print([v1.v, v1.kind])
var v2 = Variant.new("six")
System.print([v2.v, v2.kind])
var v3 = Variant.new([6]) // will give an error as argument is a List
