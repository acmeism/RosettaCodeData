import "meta" for Meta

var x
Meta.eval("x = 2")
System.print("First  x = %(x)")
var y = x // save this value

Meta.eval("x = 5")
System.print("Second x = %(x)")

Meta.eval("x = x - y")
System.print("Delta  x = %(x)")
