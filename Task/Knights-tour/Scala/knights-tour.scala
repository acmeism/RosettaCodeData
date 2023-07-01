val b=Seq.tabulate(8,8,8,8)((x,y,z,t)=>(1L<<(x*8+y),1L<<(z*8+t),f"${97+z}%c${49+t}%c",(x-z)*(x-z)+(y-t)*(y-t)==5)).flatten.flatten.flatten.filter(_._4).groupBy(_._1)
def f(p:Long,s:Long,v:Any){if(-1L!=s)b(p).foreach(x=>if((s&x._2)==0)f(x._2,s|x._2,v+x._3))else println(v)}
f(1,1,"a1")
