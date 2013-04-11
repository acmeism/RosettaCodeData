def factor(n:Int) = (1 to Math.sqrt(n)).filter(n%_== 0).flatMap(x=>List(n/x,x)).toList.sort(_>_)
