for(v<-(0 to 7).permutations.filter(v=>(0 to 7).forall(i=>(i+1 to 7).
                             forall(j=>j-i!=Math.abs(v(i)-v(j)))))){
  println("_"*15)
  v.map(i=>println("_|"*i+"Q"+"|_"*(7-i)))
}
