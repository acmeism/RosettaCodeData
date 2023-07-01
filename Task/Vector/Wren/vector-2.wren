import "./vector" for Vector2

var v1 = Vector2.new(5, 7)
var v2 = Vector2.new(2, 3)
var v3 = Vector2.fromPolar(2.sqrt, Num.pi / 4)
System.print("v1 = %(v1)")
System.print("v2 = %(v2)")
System.print("v3 = %(v3)")
System.print()
System.print("v1 + v2 = %(v1 + v2)")
System.print("v1 - v2 = %(v1 - v2)")
System.print("v1 * 11 = %(v1 * 11)")
System.print("11 * v2 = %(Vector2.scale(11, v2))")
System.print("v1 / 2  = %(v1 /  2)")
