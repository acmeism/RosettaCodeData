# Create the pivot matrix for the input matrix.
# Use "range(0;$n) as $i" to handle ill-conditioned cases.
def pivotize:
  def abs: if .<0 then -. else . end;
  length as $n
  | . as $m
  | reduce range(0;$n) as $j
      (I($n);
       # state: [row; max]
       (reduce range(0; $n) as $i
          ([$j, $m[$j][$j]|abs ];
           ($m[$i][$j]|abs) as $a
           | if $a > .[1] then [ $i, $a ] else . end) | .[0]) as $row
        | swap_rows( $j; $row)
      ) ;

# Decompose the input nxn matrix A by PA=LU and return [L, U, P].
def lup:
  def div(i;j):
    if j == 0 then if i==0 then 0 else error("\(i)/0") end
    else i/j
    end;
  . as $A
  | length as $n
  | I($n) as $L         #  matrix($n; $n; 0.0) as $L
  | matrix($n; $n; 0.0) as $U
  | ($A|pivotize) as $P
  | multiply($P;$A) as $A2
  # state: [L, U]
  | reduce range(0; $n) as $i ( [$L, $U];
      reduce range(0; $n) as $j (.;
          .[0] as $L
        | .[1] as $U
        | if ($j >= $i) then
            (reduce range(0;$i) as $k (0; . + ($U[$k][$j] * $L[$i][$k] ))) as $s1
            | [$L, ($U| setpath([$i,$j]; ($A2[$i][$j] - $s1))) ]
          else
            (reduce range(0;$j) as $k (0; . + ($U[$k][$j] * $L[$i][$k]))) as $s2
            | [ ($L | setpath([$i,$j]; div(($A2[$i][$j] - $s2) ; $U[$j][$j] ))), $U ]
          end ))
    | . + [ $P ]
;
