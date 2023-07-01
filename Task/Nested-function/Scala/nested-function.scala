   def main(args: Array[String]) {
      val sep: String=". "
      var c:Int=1;
      def go(s: String):Unit={
          println(c+sep+s)
          c=c+1
      }
      go("first")
      go("second")
      go("third")
   }
