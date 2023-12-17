import "./fmt" for Fmt

var floyd = Fn.new { |n|
   var k = 1
   for (i in 1..n) {
       for (j in 1..i) {
           Fmt.write("$*d ", (j < 9) ? 2 : 3, k)
           k = k + 1
       }
       System.print()
   }
}

System.print("Floyd(5):")
floyd.call(5)
System.print("\nFloyd(14):")
floyd.call(14)
