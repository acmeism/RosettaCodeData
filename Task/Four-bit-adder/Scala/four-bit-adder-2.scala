object FourBitAdderTest {
   import FourBitAdder._
   def main(args: Array[String]): Unit = {
      println("%4s   %4s   %4s %2s".format("A","B","S","C"))
      for(a <- 0 to 15; b <- 0 to 15){
         val (s, cOut)=fourBitAdder(a,b)
         println("%4s + %4s = %4s %2d".format(nibbleToString(a),nibbleToString(b),nibbleToString(s),cOut.toInt))
      }
   }

   implicit def toInt(b:Boolean):Int=if (b) 1 else 0
   implicit def intToBool(i:Int):Boolean=if (i==0) false else true
   implicit def intToNibble(i:Int):Nibble=((i>>>3)&1, (i>>>2)&1, (i>>>1)&1, i&1)
   def nibbleToString(n:Nibble):String="%d%d%d%d".format(n._1.toInt, n._2.toInt, n._3.toInt, n._4.toInt)
}
