def task:
  def t: "Triangle: ";
  def printTris(t1; t2; nl):
     "\(nl)\(t)\(t1) and\n\(t)\(t2)" ;

  def overlap(t1; t2):
    if triTri2D(t1; t2; 0; false; true) then "overlap" else "do not overlap" end;

  def overlapr(t1; t2):
    if triTri2D(t1; t2; 0; true; true) then "overlap (reversed)" else "do not overlap" end;

  ([ [0, 0], [5, 0], [0, 5] ] as $t1
   | [ [0, 0], [5, 0], [0, 6] ] as $t2
   | printTris($t1; $t2; ""),
     overlap($t1; $t2) ),

  ([ [0, 0], [0, 5], [5, 0] ] as $t1
   | $t1 as $t2
   | printTris($t1; $t2; "\n"),
     # need to allow reversed for this pair to avoid exception
     overlapr($t1; $t2) ),

  ([ [0, 0], [5, 0], [0, 5] ] as $t1
   | [ [-10, 0], [-5, 0], [-1, 6] ] as $t2
   | printTris($t1; $t2; "\n"),
     overlap($t1; $t2) ),

  ([ [0, 0], [5, 0], [2.5, 5] ] as $t1
   | [ [0, 4], [2.5, -1], [5, 4] ] as $t2
   | printTris($t1; $t2; "\n"),
     overlap($t1; $t2) ),

  ([ [0, 0], [1, 1], [0, 2] ] as $t1
   | ([ [2, 1], [3, 0], [3, 2] ] as $t2
      | printTris($t1; $t2; "\n"),
        overlap($t1; $t2) ),
     ( [[2, 1], [3, -2], [3, 4]] as $t2
       | printTris($t1; $t2; "\n"),
         overlap($t1; $t2) )),

  ([ [0, 0], [1, 0], [0, 1] ] as $t1
   | [ [1, 0], [2, 0], [1, 1.1] ] as $t2
   | (printTris($t1; $t2; ""),
      "which have only a single corner in contact, if boundary points collide",
      overlap($t1; $t2) ),

     (printTris($t1; $t2; "\n"),
      "which have only a single corner in contact, if boundary points do not collide",
      if triTri2D($t1; $t2; 0; false; false) then "overlap" else "do not overlap" end) );

task
