def encode(n: Long) = n ^ (n >>> 1)

def decode(n: Long) = {
  var g = 0L
  var bits = n
  while (bits > 0) {
    g ^= bits
    bits >>= 1
  }
  g
}

def toBin(n: Long) = ("0000" + n.toBinaryString) takeRight 5

println("decimal  binary   gray  decoded")
for (i <- 0 until 32) {
  val g = encode(i)
  println("%7d  %6s  %5s  %7s".format(i, toBin(i), toBin(g), decode(g)))
}
