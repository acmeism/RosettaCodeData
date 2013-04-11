def encode(s:String) = {
  s.foldLeft((0,s(0),""))( (t,c) => t match {case (i,p,s) => if (p==c) (i+1,p,s) else (1,c,s+i+p)})
    match {case (i,p,s) => s+i+p}
}
