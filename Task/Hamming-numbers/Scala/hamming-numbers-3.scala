val hamming : Stream[BigInt] = {
   def merge(inx : Stream[BigInt], iny : Stream[BigInt]) : Stream[BigInt] = {
      if (inx.head < iny.head) inx.head #:: merge(inx.tail, iny) else
      if (iny.head < inx.head) iny.head #:: merge(inx, iny.tail) else
      merge(inx, iny.tail)
   }

   1 #:: merge(hamming map (_ * 2), merge(hamming map (_ * 3), hamming map (_ * 5)))
}
