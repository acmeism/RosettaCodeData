# Input: array of dimensions
# output: {m, s}
def optimalMatrixChainOrder:
  . as $dims
  | (($dims|length) - 1) as $n
  | reduce range(1; $n) as $len ({m: [], s: []};
      reduce range(0; $n-$len) as $i (.;
        ($i + $len) as $j
        | .m[$i][$j] = infinite
        | reduce range($i; $j) as $k (.;
            ($dims[$i] * $dims [$k + 1] * $dims[$j + 1]) as $temp
            | (.m[$i][$k] + .m[$k + 1][$j] + $temp) as $cost
            | if $cost < .m[$i][$j]
              then .m[$i][$j] = $cost
              | .s[$i][$j] = $k
              else .
	      end ) )) ;

# input: {s}
def printOptimalChainOrder($i; $j):
  if $i == $j
  then [$i + 65] | implode #=> "A", "B", ...
  else "(" +
      printOptimalChainOrder($i; .s[$i][$j]) +
      printOptimalChainOrder(.s[$i][$j] + 1; $j) + ")"
  end;

def dimsList: [
    [5, 6, 3, 1],
    [1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2],
    [1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10]
];

dimsList[]
| "Dims  : \(.)",
  (optimalMatrixChainOrder
   | "Order : \(printOptimalChainOrder(0; .s|length - 1))",
     "Cost  : \(.m[0][.s|length - 1])\n" )
