import "/set" for Set

var symmetricDifference = Fn.new { |a, b| a.except(b).union(b.except(a)) }

var a = Set.new(["John", "Bob", "Mary", "Serena"])
var b = Set.new(["Jim", "Mary", "John", "Bob"])
System.print("A     = %(a)")
System.print("B     = %(b)")
System.print("A - B = %(a.except(b))")
System.print("B - A = %(b.except(a))")
System.print("A △ B = %(symmetricDifference.call(a, b))")
