   ]mymatrix=: _4]\ 1 2 _1 _4 2 3 _1 _11 _2 0 _3 22
 1 2 _1  _4
 2 3 _1 _11
_2 0 _3  22

   require 'math/misc/linear'
   gauss_jordan mymatrix
1 0 0 _8
0 1 0  1
0 0 1 _2
