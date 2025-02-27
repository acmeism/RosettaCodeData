import "./set" for Set

var a = Set.new(["John", "Bob", "Mary", "Serena"])
var b = Set.new(["Jim", "Mary", "John", "Bob"])
System.print("A     = %(a)")
System.print("B     = %(b)")
System.print("A - B = %(a.except(b))")
System.print("B - A = %(b.except(a))")
System.print("A △ B = %(a.symDiff(b))")
