# The minor of the input matrix after removing the specified row and column.
# Assumptions: the input is square and the indices are hunky dory.
def minor(rowNum; colNum):
  . as $in
  | (length - 1) as $len
  | reduce range(0; $len) as $i (null;
      reduce range(0; $len) as $j (.;
        if $i < rowNum and $j < colNum
        then .[$i][$j] = $in[$i][$j]
        elif $i >= rowNum and $j < colNum
        then .[$i][$j] = $in[$i+1][$j]
        elif $i < rowNum and $j >= colNum
        then .[$i][$j] = $in[$i][$j+1]
        else .[$i][$j] = $in[$i+1][$j+1]
        end) );

# The determinant using Laplace expansion.
# Assumption: the matrix is square
def det:
 . as $a
 | length as $nr
 | if $nr == 1 then .[0][0]
   elif $nr == 2 then .[1][1] * .[0][0] - .[0][1] * .[1][0]
   else reduce range(0; $nr) as $i (
     { sign: 1, sum: 0 };
     ($a|minor(0; $i)) as $m
     | .sum += .sign * $a[0][$i] * ($m|det)
     | .sign *= -1 )
     | .sum
   end ;

# Solve A X = D using Cramer's method
# a is assumed to be a JSON array representing the 2-d square matrix A
# d is assumed to be a JSON array representing the 1-d vector D
def cramer(a; d):
  (a | length) as $n
  | (a | det) as $ad
  | if $ad == 0 then "matrix determinant is 0" | error
    else reduce range(0; $n) as $c (null;
      (reduce range(0; $n) as $r (a; .[$r][$c] = d[$r])) as $aa
      | .[$c] = ($aa|det) / $ad )
    end ;

def a: [
    [2, -1,  5,  1],
    [3,  2,  2, -6],
    [1,  3,  3, -1],
    [5, -2, -3,  3]
];

def d:
  [ -3, -32, -47, 49 ] ;

"Solution is \(cramer(a; d))"
