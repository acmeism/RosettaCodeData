import "./big" for BigRat

var hamburgers     = BigRat.new("4000000000000000")
var milkshakes     = BigRat.two
var price1         = BigRat.fromFloat(5.5)
var price2         = BigRat.fromFloat(2.86)
var taxPc          = BigRat.fromFloat(0.0765)
var totalPc        = BigRat.fromFloat(1.0765)
var totalPreTax    = hamburgers*price1 + milkshakes*price2
var totalTax       = taxPc * totalPreTax
var totalAfterTax  = totalPreTax + totalTax
System.print("Total price before tax : %((totalPreTax).toDecimal(2))")
System.print("Tax                    :  %((totalTax).toDecimal(2))")
System.print("Total price after tax  : %((totalAfterTax).toDecimal(2))")
