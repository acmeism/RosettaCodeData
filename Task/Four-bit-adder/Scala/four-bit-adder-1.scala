object FourBitAdder {
   type Nibble=(Boolean, Boolean, Boolean, Boolean)

   def xor(a:Boolean, b:Boolean)=(!a)&&b || a&&(!b)

   def halfAdder(a:Boolean, b:Boolean)={
      val s=xor(a,b)
      val c=a && b
      (s, c)
   }

   def fullAdder(a:Boolean, b:Boolean, cIn:Boolean)={
      val (s1, c1)=halfAdder(a, cIn)
      val (s, c2)=halfAdder(s1, b)
      val cOut=c1 || c2
      (s, cOut)
   }

   def fourBitAdder(a:Nibble, b:Nibble)={
      val (s0, c0)=fullAdder(a._4, b._4, false)
      val (s1, c1)=fullAdder(a._3, b._3, c0)
      val (s2, c2)=fullAdder(a._2, b._2, c1)
      val (s3, cOut)=fullAdder(a._1, b._1, c2)
      ((s3, s2, s1, s0), cOut)
   }
}
