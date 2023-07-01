CL-USER> (defparameter *list* '(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo))
*LIST*
CL-USER> (position 'Bush *list*)
4
CL-USER> (position 'Bush *list* :from-end t)
7
CL-USER> (position 'Washington *list*)
NIL
