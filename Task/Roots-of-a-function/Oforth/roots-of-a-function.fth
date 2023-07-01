: findRoots(f, a, b, st)
| x y lasty |
   a f perform dup ->y ->lasty

   a b st step: x [
      x f perform -> y
      y ==0 ifTrue: [ System.Out "Root found at " << x << cr ]
      else: [ y lasty * sgn -1 == ifTrue: [ System.Out "Root near " << x << cr ] ]
      y ->lasty
      ] ;

: f(x)   x 3 pow x sq 3 * - x 2 * + ;
