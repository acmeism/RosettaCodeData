def encode(n: Int)    = (n ^ (n >>> 1)).toBinaryString
def decode(s: String) = Integer.parseInt( s.scanLeft(0)(_ ^ _.asDigit).tail.mkString , 2)

println("decimal  binary   gray  decoded")
for (i <- 0 to 31; g = encode(i))
  println("%7d  %6s  %5s  %7s".format(i, i.toBinaryString, g, decode(g)))
