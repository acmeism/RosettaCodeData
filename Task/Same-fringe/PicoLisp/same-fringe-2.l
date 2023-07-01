: (balance '*Tree1 (range 1 7))
-> NIL
: (for N (5 4 6 3 7 1 2) (idx '*Tree2 N T))
-> NIL

: (view *Tree1 T)
      7
   6
      5
4
      3
   2
      1
-> NIL

: (view *Tree2 T)
      7
   6
5
   4
      3
            2
         1
-> NIL

: (cmpTrees *Tree1 *Tree2)
-> T
