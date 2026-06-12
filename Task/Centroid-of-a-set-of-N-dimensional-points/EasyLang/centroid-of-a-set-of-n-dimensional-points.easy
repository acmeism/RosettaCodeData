func[] centroid pts[][] .
   dim = len pts[1][]
   len r[] dim
   for pt[] in pts[][]
      for i to dim
         r[i] += pt[i]
      .
   .
   for i to dim : r[i] /= len pts[][]
   return r[]
.
print centroid [ [ 1 ], [ 2 ], [ 3 ] ]
print centroid [ [ 8, 2 ], [ 0, 0 ] ]
print centroid [ [ 5, 5, 0 ], [ 10, 10, 0 ] ]
print centroid [ [ 1, 3.1, 6.5 ], [ -2, -5, 3.4 ], [ -7, -4, 9 ], [ 2, 0, 3 ] ]
print centroid [ [ 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0 ], [ 0, 0, 1, 0, 0 ], [ 0, 1, 0, 0, 0 ] ]
