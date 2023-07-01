require 'matrix'

m = Matrix[[-1, -2, 3, 2],
           [-4, -1, 6, 2],
           [ 7, -8, 9, 1],
           [ 1, -2, 1, 3]]

pp m.inv.row_vectors
