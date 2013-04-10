scala> def if2[A](x: => Boolean)(y: => Boolean)(xyt: => A) = new {
     |   def else1(xt: => A) = new {
     |     def else2(yt: => A) = new {
     |       def orElse(nt: => A) = {
     |         if(x) {
     |           if(y) xyt else xt
     |         } else if(y) {
     |           yt
     |         } else {
     |           nt
     |         }
     |       }
     |     }
     |   }
     | }
if2: [A](x: => Boolean)(y: => Boolean)(xyt: => A)java.lang.Object{def else1(xt: => A): java.lang.Object{def else2(yt: =>
 A): java.lang.Object{def orElse(nt: => A): A}}}
