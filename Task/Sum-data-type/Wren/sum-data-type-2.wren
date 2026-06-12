import "./dynamic" for Union

var Variant = Union.create("Variant", [Num, String])

var v1 = Variant.new(6)
System.print([v1.value, v1.kind])
var v2 = Variant.new("six")
System.print([v2.value, v2.kind])
var v3 = Variant.new([6]) // will give an error as argument is a List
