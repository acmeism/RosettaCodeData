import "./big" for BigInt, BigRat

var sylvester = [BigInt.two]
var prod = BigInt.two
var count = 1
while (true) {
    var next = prod + 1
    sylvester.add(next)
    count = count + 1
    if (count == 10) break
    prod = prod * next
}
System.print("The first 10 terms in the Sylvester sequence are:")
System.print(sylvester.join("\n"))

var sumRecip = sylvester.reduce(BigRat.zero) { |acc, s| acc + BigRat.new(1, s) }
System.print("\nThe sum of their reciprocals as a rational number is:")
System.print (sumRecip)
System.print("\nThe sum of their reciprocals as a decimal number (to 211 places) is:")
System.print(sumRecip.toDecimal(211))
