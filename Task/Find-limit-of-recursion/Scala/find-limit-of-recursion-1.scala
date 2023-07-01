def recurseTest(i:Int):Unit={
   try{
      recurseTest(i+1)
   } catch { case e:java.lang.StackOverflowError =>
      println("Recursion depth on this system is " + i + ".")
   }
}
recurseTest(0)
