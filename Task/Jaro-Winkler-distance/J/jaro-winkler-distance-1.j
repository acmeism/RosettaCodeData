jaro=: {{
   Eq=. (x=/y)*(<.<:-:x>.&#y)>:|x -/&i.&# y
   xM=. (+./"1 Eq)#x
   yM=. (+./"2 Eq)#y
   M=.  xM <.&# yM
   T=.  -: +/ xM ~:&(M&{.) yM
   3%~ (M%#x) + (M%#y) + (M-T)%M
}}

jarowinkler=: {{
   p=. 0.1
   l=. +/*/\x =&((4<.x<.&#y)&{.) y
   simj=. x jaro y
   -.simj + l*p*-.simj
}}
