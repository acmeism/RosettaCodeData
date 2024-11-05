### Generic utilities
def sigma(stream): reduce stream as $x (0; . + $x);

# Hilbert-Schmidt norm:
def frobenius:
  sigma( flatten[] | .*. ) | sqrt;

### Matrices
# Create an m x n matrix
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [[range(0;n) | init]]
  elif m > 0 then
    matrix(1;n;init) as $row
    | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end;

# A and B must be (multi-dimensional) vectors of the same shape
def vector_add($A;$B):
  if ($A|type) == "array"
  then reduce range(0; $A|length) as $i ([];
    . + [vector_add($A[$i]; $B[$i])] )
  else $A + $B
  end;

def vector_negate:
  if type == "array"
  then map(vector_negate)
  else - .
  end;

def vector_subtract($A;$B):
  vector_add($A; $B|vector_negate);

# A should be m by n; and B n by p
# Pre-allocating the resultant matrix results in a very small net speedup.
def multiply($A; $B):
    ($A|length) as $m
  | ($A[0]|length) as $n
  | ($B[0]|length) as $p
  | reduce range(0; $m) as $i
      (matrix($m; $p; 0);    # initialize to avoid resizing
       reduce range(0;$p) as $j (.;
          .[$i][$j] = reduce range(0;$n) as $k
            (0;
             # Cij = innerproduct of row i, column j
             . + $A[$i][$k] * $B[$k][$j] ))) ;

def submatrix($m1; $m2; $n1; $n2):
  .[$m1:$m2] | map( .[$n1:$n2]);

def submatrix($A; $m1; $m2; $n1; $n2):
  $A | submatrix($m1; $m2; $n1; $n2);

def rowwise_extend($A;$B):
  reduce range(0; $A|length) as $i ([]; . + [$A[$i] + $B[$i]]);

### Strassen multiplication of n*n square matrices where n is a power of 2.
def Strassen($A; $B):
  ($A[0]|length) as $n
  | if $n == 1 then multiply($A; $B)
    else
      submatrix($A; 0;    $n/2; 0;    $n/2) as $A11
    | submatrix($A; 0;    $n/2; $n/2; $n)   as $A12
    | submatrix($A; $n/2; $n;   0;    $n/2) as $A21
    | submatrix($A; $n/2; $n;   $n/2; $n)   as $A22
    | submatrix($B; 0;    $n/2; 0;    $n/2) as $B11
    | submatrix($B; 0;    $n/2; $n/2; $n)   as $B12
    | submatrix($B; $n/2; $n; 0;      $n/2) as $B21
    | submatrix($B; $n/2; $n; $n/2+0; $n)   as $B22

    | Strassen( vector_subtract($A12; $A22); vector_add($B21; $B22)) as $P1
    | Strassen( vector_add($A11; $A22); vector_add($B11; $B22))      as $P2
    | Strassen( vector_subtract($A11; $A21); vector_add($B11; $B12)) as $P3
    | Strassen( vector_add($A11; $A12); $B22)                        as $P4
    | Strassen( $A11; vector_subtract($B12; $B22))                   as $P5
    | Strassen( $A22; vector_subtract($B21; $B11) )                  as $P6
    | Strassen( vector_add($A21; $A22); $B11)                        as $P7

    | vector_add(vector_subtract(vector_add($P1; $P2); $P4); $P6)    as $C11
    | vector_add($P4; $P5)                                           as $C12
    | vector_add($P6; $P7)                                           as $C21
    | vector_add(vector_subtract($P2; $P3); vector_subtract($P5;$P7)) as $C22
    # [C11 C12; C21 C22]
    | rowwise_extend($C11; $C12) + rowwise_extend($C21; $C22)
    end
;

# ## Examples
def A: [[1, 2], [3, 4]];
def B: [[5, 6], [7, 8]];
def C: [[1, 1, 1, 1],
        [2, 4, 8, 16],
        [3, 9, 27, 81],
        [4, 16, 64, 256]];
def D: [[4,     -3,    4/3, -1/4],
        [-13/3, 19/4, -7/3, 11/24],
        [3/2,   -2,    7/6, -1/4],
        [-1/6, 1/4,   -1/6, 1/24]];
def E: [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]];
def F: [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0,   1,  0], [ 0,  0,  0,  1]];

def r: (2|sqrt)/2;
def R: [[r, r], [-r, r]];

"A*B == Strassen(A;B): \((multiply(A; B) == Strassen(A; B)))",

"Frobenius norm for C*D - Strassen(C;D): \(vector_subtract(multiply(C; D); Strassen(C; D)) | frobenius)",

"E*F == Strassen(E;F): \(multiply(E; F) == Strassen( E; F))",

"R*R == Strassen(R;R): \(multiply(R ; R) == Strassen(R; R))"
