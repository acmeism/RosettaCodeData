import "/big" for BigInt

var fermat = Fn.new { |n| BigInt.two.pow(2.pow(n)) + 1 }

var fns = List.filled(10, null)
System.print("The first 10 Fermat numbers are:")
for (i in 0..9) {
    fns[i] = fermat.call(i)
    System.print("F%(String.fromCodePoint(0x2080+i)) = %(fns[i])")
}

System.print("\nFactors of the first 7 Fermat numbers:")
for (i in 0..6) {
    System.write("F%(String.fromCodePoint(0x2080+i)) = ")
    var factors = BigInt.primeFactors(fns[i])
    System.write("%(factors)")
    if (factors.count == 1) {
        System.print(" (prime)")
    } else if (!factors[1].isProbablePrime(5)) {
        System.print(" (second factor is composite)")
    } else {
        System.print()
    }
}
