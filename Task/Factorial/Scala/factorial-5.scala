scala> implicit def IntToFac(i : Int) = new {
     |   def ! = (2 to i).foldLeft(BigInt(1))(_*_)
     | }
IntToFac: (i: Int)java.lang.Object{def !: scala.math.BigInt}

scala> 20!
res0: scala.math.BigInt = 2432902008176640000

scala> 100!
res1: scala.math.BigInt = 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
