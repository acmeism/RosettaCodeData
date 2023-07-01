Property new: Spherical(r)
Spherical method: radius  @r ;
Spherical method: setRadius  := r ;
Spherical method: perimeter  @r 2 * PI * ;
Spherical method: surface   @r sq PI * 4 * ;

Object Class new: Ballon(color)
Ballon is: Spherical
Ballon method: initialize(color, r)  color := color self setRadius(r) ;

Object Class new: Planete(name)
Planete is: Spherical
Planete method: initialize(n, r)  n := name self setRadius(r) ;
