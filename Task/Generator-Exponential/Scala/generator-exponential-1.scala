object Generators {
   def main(args: Array[String]): Unit = {
      def squares(n:Int=0):Stream[Int]=(n*n) #:: squares(n+1)
      def cubes(n:Int=0):Stream[Int]=(n*n*n) #:: cubes(n+1)
		
      def filtered(s:Stream[Int], c:Stream[Int]):Stream[Int]={
         if(s.head>c.head) filtered(s, c.tail)
         else if(s.head<c.head) Stream.cons(s.head, filtered(s.tail, c))
         else filtered(s.tail, c)
      }

      filtered(squares(), cubes()) drop 20 take 10 print
   }
}
