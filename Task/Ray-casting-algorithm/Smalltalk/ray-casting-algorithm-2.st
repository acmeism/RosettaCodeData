|points names polys|

points := {
           0@0 . 10@0 . 10@10 . 0@10 .
           2.5@2.5 . 7.5@2.5 . 7.5@7.5 .
           2.5@7.5 . 0@5 . 10@5 .
           3@0 . 7@0 . 7@10 . 3@10
          }.

names := { 'square' . 'square hole' . 'strange' . 'exagon' }.

polys := OrderedCollection new.

polys add:
      (
        Polygon fromPoints: points
                and: { {1 . 2}. {2 . 3}. {3 . 4}. {4 . 1} }
      ) ;
      add:
      (
        Polygon fromPoints: points
                and: { {1 . 2}. {2 . 3}. {3 . 4}. {4 . 1}. {5 . 6}. {6 . 7}. {7 . 8}. {8 . 5} }
      ) ;
      add:
      (
        Polygon fromPoints: points
                and: { {1 . 5}. {5 . 4}. {4 . 8}. {8 . 7}. {7 . 3}. {3 . 2}. {2 . 5} }
      ) ;
      add:
      (
        Polygon fromPoints: points
                and: { {11 . 12}. {12 . 10}. {10 . 13}. {13 . 14}. {14 . 9}. {9 . 11} }
      ).

{ 5@5 . 5@8 . -10@5 . 0@5 . 10@5 . 8@5 . 10@10 }
do: [ :p |
  1 to: 4 do: [ :i |
   ('point %1 inside %2? %3' %
     { p . names at: i. (polys at: i) pointInside: p }) displayNl
  ].
  ' ' displayNl.
]
