def mean(a:Array[Double])=a.sum / a.size
def stddev(a:Array[Double])={
   val sum = a.fold(0.0)((a, b) => a + math.pow(b,2))
   math.sqrt((sum/a.size) - math.pow(mean(a),2))
}
def hist(a:Array[Double]) = {
   val grouped=(SortedMap[Double, Array[Double]]() ++ (a groupBy (x => math.rint(x*10)/10)))
   grouped.map(v => (v._1, v._2.size))
}
def printHist(a:Array[Double])=for((g,v) <- hist(a)){
   println(s"$g: ${"*"*(205*v/a.size)} $v")
}

for(n <- Seq(100,1000,10000)){
   val a = Array.fill(n)(Random.nextDouble)
   println(s"$n numbers")
   println(s"Mean: ${mean(a)}")
   println(s"StdDev: ${stddev(a)}")
   printHist(a)
   println
}
