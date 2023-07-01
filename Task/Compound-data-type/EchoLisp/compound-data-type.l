(lib 'struct)
    (struct Point (x y))
    (Point 3 4)
  → #<Point> (3 4)

;; run-time type checking is possible
(lib 'types)
    (struct Point (x y))
    (struct-type Point Number Number)
    (Point 3 4)
    (Point 3 'albert)
❌ error: #number? : type-check failure : albert → 'Point:y'
