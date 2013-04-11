def zigzag(n:int) = {
 var indices = List[Tuple2[Int,Int]]()
 var array = new Array[Array[Int]](n,n)

 (0 until n*n).foldLeft(indices)((l,i) => l + (i%n,i/n)).
   sort{case ((x,y),(u,v)) => if (x+y == u+v)
                    		if ((x+y) % 2 == 0) x<u else y<v
                              else (x+y) < (u+v) }.
   zipWithIndex.foldLeft(array) {case (a,((x,y),i)) => a(y)(x) = i; a}
}
