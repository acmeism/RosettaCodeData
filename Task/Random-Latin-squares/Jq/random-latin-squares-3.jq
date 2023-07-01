# Include the utilities e.g. by
# include "random-latin-squares.utilities" {search: "."};

# Determine orthogonality of two arrays, confining attention
# to the first $n elements in each:
def orthogonal($a; $b; $n):
   first( (range(0; $n) | if $a[.] == $b[.] then 0 else empty end) // 1) | . == 1;

# Are the two arrays orthogonal up to the length of the shorter?
def orthogonal($a; $b):
   ([$a, $b | length] | min) as $min
   | orthogonal($a; $b; $min);

# Is row $i orthogonal to all the previous rows?
def orthogonal($i):
  . as $in
  | .[$i] as $row
  | all(range(0;$i); orthogonal($row; $in[.]));

# verify columnwise orthogonality
def columnwise:
  length as $n
  | transpose as $t
  | all( range(1;$n); . as $i | $t | orthogonal($i)) ;

def addLast:
  (.[0] | length) as $n
  | [range(0; $n)] as $range
  | [range(0; $n) as $i
     | ($range - column($i))[0]  ] as $last
  | . + [$last] ;

# input: an array being a permutation of [range(0;$n)] for some $n
# output: a Latin Square selected at random from all the candidates
def extend:
  (.[0] | length) as $n
  | if length >= $n then .
    elif length == $n - 1 then addLast
    else ([range(0; $n)] | knuthShuffle) as $row
    | (. + [$row] )
    | if orthogonal(length - 1) and columnwise then extend else empty end
    end ;

# Generate a Latin Square.
# The input should be an integer specifying its size.
def latinSquare:
  . as $n
  | if $n <= 0 then []
    else
    [ [range(0; $n)] | knuthShuffle]
    | first(repeat(extend))
    # | (if columnwise then . else debug end)  # internal check
    end ;

# If the input is a positive integer, $n, generate and print an $n x $n Latin Square.
# If it is not number, echo it.
def printLatinSquare:
  if type == "number"
  then latinSquare
  | .[] | map(lpad(3)) | join(" ")
  else .
  end;

# $order should be in 1 .. 5 inclusive
# If $n is null, then use 10 * $counts[$order]
def stats($order; $n):
  # table of counts:
  [0,1,2,12,576,161280] as $counts
  | $counts[$order] as $possibilities
  | (if $n then $n else 10 * $possibilities end) as $n
  | reduce range(0;$n) as $i ({};
      ($order|latinSquare|flatten|join("")) as $row
      | .[$row] += 1)
  | # ([histogram(.[])] | sort[] | join(" ")),
    "Number of LS(\($order)): \($n)",
    (if length == $possibilities
     then "All \($possibilities) possibilities have been generated."
     else "Of \($possibilities) possibilities, only \(length) were generated."
     end),
    "Chi-squared statistic (df=\($possibilities-1)): \( [.[]] | chiSquared( $n / $possibilities))";


stats(3;null), "",
stats(4;5760), ""
stats(4;5760)
