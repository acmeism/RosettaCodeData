import "./ioutil" for Input, Stdin

var divmod = Fn.new { |a, b| [(a / b).floor, a % b] }

var a = Input.integer("first number:     ")
var b = Input.integer("second number:    ")
System.print("sum:              %(a + b)")
System.print("difference:       %(a - b)")
System.print("product:          %(a * b)")
System.print("integer quotient: %((a / b).floor)")
System.print("remainder:        %(a % b)")
System.print("exponentiation:   %(a.pow(b))")
System.print("divmod:           %(divmod.call(a, b))")
