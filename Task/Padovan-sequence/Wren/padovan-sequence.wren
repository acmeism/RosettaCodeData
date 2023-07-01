import "/big" for BigRat
import "/dynamic" for Struct

var padovanRecur = Fn.new { |n|
    var p = List.filled(n, 1)
    if (n < 3) return p
    for (i in 3...n) p[i] = p[i-2] + p[i-3]
    return p
}

var padovanFloor = Fn.new { |n|
    var p = BigRat.fromDecimal("1.324717957244746025960908854")
    var s = BigRat.fromDecimal("1.0453567932525329623")
    var f = List.filled(n, 0)
    var pow = BigRat.one
    f[0] = (pow/p/s + 0.5).floor.toInt
    for (i in 1...n) {
        f[i] = (pow/s + 0.5).floor.toInt
        pow = pow * p
    }
    return f
}

var LSystem = Struct.create("LSystem", ["rules", "init", "current"])

var step = Fn.new { |lsys|
    var s = ""
    if (lsys.current == "") {
        lsys.current = lsys.init
    } else {
        for (c in lsys.current) s = s + lsys.rules[c]
        lsys.current = s
    }
    return lsys.current
}

var padovanLSys = Fn.new { |n|
    var rules = {"A": "B", "B": "C", "C": "AB"}
    var lsys = LSystem.new(rules, "A", "")
    var p = List.filled(n, null)
    for (i in 0...n) p[i] = step.call(lsys)
    return p
}

System.print("First 20 members of the Padovan sequence:")
System.print(padovanRecur.call(20))

var recur = padovanRecur.call(64)
var floor = padovanFloor.call(64)
var areSame = (0...64).all { |i| recur[i] == floor[i] }
var s = areSame ? "give" : "do not give"
System.print("\nThe recurrence and floor based functions %(s) the same results for 64 terms.")

var p = padovanLSys.call(32)
var lsyst = p.map { |e| e.count }.toList
System.print("\nFirst 10 members of the Padovan L-System:")
System.print(p.take(10).toList)
System.print("\nand their lengths:")
System.print(lsyst.take(10).toList)

recur = recur.take(32).toList
areSame = (0...32).all { |i| recur[i] == lsyst[i] }
s = areSame ? "give" : "do not give"
System.print("\nThe recurrence and L-system based functions %(s) the same results for 32 terms.")
