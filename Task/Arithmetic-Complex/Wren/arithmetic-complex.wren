import "./complex" for Complex

var x = Complex.new(1, 3)
var y = Complex.new(5, 2)
System.print("x     =  %(x)")
System.print("y     =  %(y)")
System.print("x + y =  %(x + y)")
System.print("x - y =  %(x - y)")
System.print("x * y =  %(x * y)")
System.print("x / y =  %(x / y)")
System.print("-x    =  %(-x)")
System.print("1 / x =  %(x.inverse)")
System.print("x*    =  %(x.conj)")
