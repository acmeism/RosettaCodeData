import "./gmp" for Mpf

var prec = (101/0.30103).round
var gamma = Mpf.euler(prec)
System.print(gamma.toString(10, 100))
