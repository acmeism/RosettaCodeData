import "./gmp" for Mpf

var x = Mpf.new(324)
var zeta = x.zetaUi(3)
System.print(zeta.toString(101))
