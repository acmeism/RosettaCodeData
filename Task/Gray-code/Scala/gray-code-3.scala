def decode(n:Long)={
  def calc(g:Long,bits:Long):Long=if (bits>0) calc(g^bits, bits>>1) else g
  calc(0, n)
}
