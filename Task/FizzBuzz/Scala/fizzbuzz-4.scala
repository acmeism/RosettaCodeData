def f(a:Int,b:Int,c:String, d:String):String = if(a % b == 0) c else d
for(i <- 1 to 100) println(f(i,15,"FizzBuzz", f(i,3,"Fizz", f(i,5,"Buzz", i.toString))))
