import "./vector" for Vector3

var a = Vector3.new(3, 4, 5)
var b = Vector3.new(4, 3, 5)
var c = Vector3.new(-5, -12, -13)
System.print("a = %(a)")
System.print("b = %(b)")
System.print("c = %(c)")
System.print()
System.print("a . b     = %(a.dot(b))")
System.print("a x b     = %(a.cross(b))")
System.print("a . b x c = %(a.scalarTripleProd(b, c))")
System.print("a x b x c = %(a.vectorTripleProd(b, c))")
