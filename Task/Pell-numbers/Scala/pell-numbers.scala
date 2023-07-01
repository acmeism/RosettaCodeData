val pellNumbers: LazyList[BigInt] =
  BigInt("0") #:: BigInt("1") #::
    (pellNumbers zip pellNumbers.tail).
      map{ case (a,b) => 2*b + a }

val pellLucasNumbers: LazyList[BigInt] =
  BigInt("2") #:: BigInt("2") #::
    (pellLucasNumbers zip pellLucasNumbers.tail).
      map{ case (a,b) => 2*b + a }

val pellPrimes: LazyList[BigInt] =
  pellNumbers.tail.tail.
    filter{ case p => p.isProbablePrime(16) }

val pellIndexOfPrimes: LazyList[BigInt] =
  pellNumbers.tail.tail.
    filter{ case p => p.isProbablePrime(16) }.
    map{ case p => pellNumbers.indexOf(p) }

val pellNSWnumbers: LazyList[BigInt] =
  (pellNumbers.zipWithIndex.collect{ case (p,i) if i%2 == 0 => p}
    zip
   pellNumbers.zipWithIndex.collect{ case (p,i) if i%2 != 0 => p}).
    map{ case (a,b) => a + b }

val pellSqrt2Numerator: LazyList[BigInt] =
  BigInt(1) #:: BigInt(3) #::
    (pellSqrt2Numerator zip pellSqrt2Numerator.tail).
      map{ case (a,b) => 2*b + a }

val pellSqrt2: LazyList[BigDecimal] =
  (pellSqrt2Numerator zip pellNumbers.tail).
    map{ case (n,d) => BigDecimal(n)/BigDecimal(d) }

val pellSqrt2asString: LazyList[String] =
  (pellSqrt2Numerator zip pellNumbers.tail).
    map{ case (n,d) => s"$n/$d" }

val pellHypotenuse: LazyList[BigInt] =
  pellNumbers.tail.tail.zipWithIndex.collect{ case (p,i) if i%2 != 0 => p }

val pellShortLeg: LazyList[BigInt] =
  LazyList.from(3,2).map{ case s => pellNumbers.take(s).sum }

val pellTriple: LazyList[(BigInt,BigInt,BigInt)] =
  (pellHypotenuse zip pellShortLeg).
    map{ case (h,s) => (s,s+1,h)}

// Output
{ println("7 Tasks")
  println("-------")
  println(pellNumbers.take(10).mkString("1. Pell Numbers: ", ",", "\n"))
  println(pellLucasNumbers.take(10).mkString("2. Pell-Lucas Numbers: ", ",", "\n"))
  println((pellSqrt2asString zip pellSqrt2).take(10).
    map { case (f, d) => s"$f = $d" }.
    mkString("3. Square-root of 2 Approximations: \n\n",
      "\n", "\n"))
  println(pellPrimes.take(10).mkString("4. Pell Primes: \n\n", "\n", "\n"))
  println(pellIndexOfPrimes.take(10).mkString("5. Pell Index of Primes: ", ",", "\n"))
  println(pellNSWnumbers.take(10).mkString("6. Newman-Shank-Williams Numbers: \n\n", "\n", "\n"))
  println(pellTriple.take(10).mkString("7. Near Right-triangle Triples: \n\n", "\n", "\n"))
}
