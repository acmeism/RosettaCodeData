include FMSVT.f

:class point
 cell bytes x
 cell bytes y
 :m print x ? y ? ;m
 :m get ( -- x y ) x @ y @ ;m
 :m :init ( x y -- ) y ! x ! ;m
 :m copy ( -- obj) self get heap> point ;m
;class

23 5 point p
p print
p copy dup print <free

:class circle <super point
 cell bytes r
 :m print super print r ? ;m
 :m get ( -- x y r) super get r @ ;m
 :m :init ( x y r --) r ! super :init ;m
 :m copy ( -- obj) self get heap> circle ;m
;class

4 5 2 circle c
c print
c copy dup print <free
