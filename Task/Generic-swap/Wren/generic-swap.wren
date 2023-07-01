var swap = Fn.new { |l| l.swap(0, 1) }

var a = 6
var b = 3
var c = [a, b]
swap.call(c) // pass a list instead of individual variables
a = c[0] // unpack
b = c[1] // ditto
System.print("a is now %(a)")
System.print("b is now %(b)")
System.print()

// all user defined classes are reference types
class Box {
    construct new(v) { _v = v }
    v { _v }
    v=(value) { _v = value }
}

// by passing boxed arguments we can mutate them
var boxSwap = Fn.new { |a, b|
    var t = a.v
    a.v = b.v
    b.v = t
}

var d = Box.new(4)
var e = Box.new(8)
boxSwap.call(d, e)
d = d.v // unbox
e = e.v // ditto
System.print("d is now %(d)")
System.print("e is now %(e)")
