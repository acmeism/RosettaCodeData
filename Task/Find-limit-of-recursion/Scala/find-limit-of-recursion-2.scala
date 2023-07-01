def recurseTailRec(i:Int):Unit={
   if(i%100000==0) println("Recursion depth is " + i + ".")
   recurseTailRec(i+1)
}
