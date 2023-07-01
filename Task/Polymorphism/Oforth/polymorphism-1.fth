Object Class new: Point(x, y)
Point method: initialize(x, y)  x := x y := y ;
Point method: _x   @x ;
Point method: _y   @y ;
Point method: <<   "(" << @x << ", " << @y << ")" << ;

Object Class new: Circle(x, y, r)
Circle method: initialize(x, y, r)  x := x y := y r := r ;
Circle method: _x  @x ;
Circle method: _y  @y ;
Circle method: _r  @r ;
Circle method: <<  "(" << @x << ", " << @y << ", " << @r << ")" << ;

Circle classMethod: newFromPoint(aPoint, r)  self new(aPoint _x, aPoint _y, r) ;
