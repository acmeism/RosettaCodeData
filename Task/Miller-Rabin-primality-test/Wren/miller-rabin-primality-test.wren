import "./big" for BigInt

var iters = 10
// find all primes < 100
System.print("The following numbers less than 100 are prime:")
System.write("2 ")
for (i in 3..99) {
    if (BigInt.new(i).isProbablePrime(iters)) System.write("%(i) ")
}
System.print("\n")
var bia = [
    BigInt.new("4547337172376300111955330758342147474062293202868155909489"),
    BigInt.new("4547337172376300111955330758342147474062293202868155909393")
]
for (bi in bia) {
    System.print("%(bi) is %(bi.isProbablePrime(iters) ? "probably prime" : "composite")")
}
