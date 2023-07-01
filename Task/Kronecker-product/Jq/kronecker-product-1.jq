def kprod(a; b):

  # element-wise multiplication of a matrix by a number, "c"
  def multiply(c): map( map(. * c) );

  # "right" should be a vector with the same length as the input
  def laminate(right):
    [range(0; right|length) as $i
    | (.[$i] + [right[$i]]) ];

  # "matrix" and the input matrix should have the same number of rows
  def addblock(matrix):
    reduce (matrix|transpose)[] as $v (.; laminate($v));

  (a[0]|length) as $m
  | reduce range(0; a|length) as $i ([];
      . + reduce range(0; $m) as $j ([];
        addblock( b | multiply(a[$i][$j]) ) ));
