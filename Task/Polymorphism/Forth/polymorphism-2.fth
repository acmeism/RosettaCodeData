include FMS-SI.f

:class point
  ivar x  \ instance variable
  ivar y
  :m print x ? y ? ;m  \ define print method
  :m get ( -- x y ) x @ y @ ;m
  :m put ( x y -- ) y ! x ! ;m
  :m copy ( -- point-obj2 )
     self get heap> point dup >r put r> ;m
;class

point p1  \ instantiate object p1
23 5 p1 put
p1 print
p1 copy value p2 \ copy constructor
p2 print
p2 <free  \ destructor

.. p1.x ?   \ print just x
.. p1.y ?   \ print just y
8 .. p1.x ! \ change just x
9 .. p1.y ! \ change just y


:class circle
  point center  \ re-use point class for instance variable
  ivar radius
  :m print center print radius ? ;m  \ send print message to instance variable
  :m get ( -- x y r )
    center get radius @ ;m
  :m put ( x y r -- )
    radius ! center put ;m
  :m copy ( -- circle-obj2 )
     self get heap> circle dup >r put r> ;m
;class

circle c1
4 5 2 c1 put
c1 print
c1 copy value c2
c2 print
c2 <free

.. c1.center print \ print just center
.. c1.center.x ?   \ print just x
.. c1.center.y ?   \ print just y
.. c1.radius ?     \ print just radius
p1 get .. c1.center put \ change just center using a point
100 .. c1.radius ! \ change just radius
