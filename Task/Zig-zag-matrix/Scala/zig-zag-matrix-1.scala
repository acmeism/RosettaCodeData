def zigzag(n:int) = {
  var l = List[Tuple2[int,int]]()
  (0 until n*n) foreach {i=>l = l + (i%n,i/n)}
  l = l.sort{case ((x,y),(u,v)) => if (x+y == u+v)
                                     if ((x+y) % 2 == 0) x<u else y<v
                                   else (x+y) < (u+v) }
  var a = new Array[Array[int]](n,n)
  l.zipWithIndex foreach {case ((x,y),i) => a(y)(x) = i}
  a
}
