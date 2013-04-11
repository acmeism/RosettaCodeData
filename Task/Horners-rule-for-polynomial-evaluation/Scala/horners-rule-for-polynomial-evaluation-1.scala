def horner(coeffs:List[Double], x:Double)=
   coeffs.reverse.foldLeft(0.0){(a,c)=> a*x+c}
