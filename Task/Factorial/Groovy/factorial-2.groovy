def iFact = { (it > 1) ? (2..it).inject(1 as BigInteger) { i, j -> i*j } : 1 }
