import "/trait" for Cloneable, CloneableSeq
import "/seq" for Lst

class MyMap is Cloneable {
    construct new (m) {
        if (m.type != Map) Fiber.abort("Argument must be a Map.")
        _m = m
    }

    m { _m }

    toString { _m.toString }

    clone() {
        // Map keys are always immutable built-in types so we only need to worry about
        // their values which can be anything.
        var m2 = {}
        for (me in _m) {
            var v = me.value
            m2[me.key] = (v is List) ? Lst.clone(v) :
                         (v is Cloneable || v is CloneableSeq) ? v.clone() : v
        }
        return MyMap.new(m2)
    }
}

var my = MyMap.new({"a": 0, "b": 1, "c": [2, 3], "d": MyMap.new({"e": 4})})
var my2 = my.clone()
System.print("Before any changes:")
System.print("  my  = %(my)")
System.print("  my2 = %(my2)")
// now change my2
my2.m["a"] = 5
my2.m["b"] = 6
my2.m["c"][0] = 7
my2.m["c"][1] = 8
my2.m["d"].m["e"] = 9
my2.m["d"].m["f"] = 10
System.print("\nAfter changes to my2:")
System.print("  my  = %(my)")
System.print("  my2 = %(my2)")
