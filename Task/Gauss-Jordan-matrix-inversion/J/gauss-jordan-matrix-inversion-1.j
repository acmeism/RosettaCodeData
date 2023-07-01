require 'math/misc/linear'
augmentR_I1=: ,. e.@i.@#       NB. augment matrix on the right with its Identity matrix
matrix_invGJ=: # }."1 [: gauss_jordan@augmentR_I1
