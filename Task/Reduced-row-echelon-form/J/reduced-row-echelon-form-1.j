NB.*pivot v Pivot at row, column
NB. form: (row,col) pivot M
pivot=: dyad define
  'r c'=. x
  col=. c{"1 y
  y - (col - r = i.#y) */ (r{y) % r{col
)

NB.*gauss_jordan v Gauss-Jordan elimination (full pivoting)
NB. y is: matrix
NB. x is: optional minimum tolerance, default 1e_15.
NB.   If a column below the current pivot has numbers of magnitude all
NB.   less then x, it is treated as all zeros.
gauss_jordan=: verb define
  1e_15 gauss_jordan y
:
  mtx=. y
  'r c'=. $mtx
  rows=. i.r
  i=. j=. 0
  max=. i.>./
  while. (i<r) *. j<c do.
    k=. max col=. | i}. j{"1 mtx
    if. 0 < x-k{col do.           NB. if all col < tol, set to 0:
      mtx=. 0 (<(i}.rows);j) } mtx
    else.                         NB. otherwise sort and pivot:
      if. k do.
        mtx=. (<i,i+k) C. mtx
      end.
      mtx=. (i,j) pivot mtx
      i=. >:i
    end.
    j=. >:j
  end.
  mtx
)
