# Create an m x n matrix,
# it being understood that:
# matrix(0; _; _) evaluates to []
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [[range(0;n) | init]]
  elif m > 0 then
    [range(0;n) | init] as $row
    | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end;

def mprint($dec):
   def max(s): reduce s as $x (null; if . == null or $x > . then $x else . end);
   def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

   pow(10; $dec) as $power
   | def p: (. * $power | round) / $power;
   (max(.[][] | p | tostring | length) + 1) as $w
   | . as $in
   | range(0; length) as $i
   | reduce range(0; .[$i]|length) as $j ("|"; . + ($in[$i][$j]|p|lpad($w)))
   | . + " |" ;

# Swaps two rows of the input matrix using IO==0
def swapRows(rowNum1; rowNum2):
  if (rowNum1 == rowNum2)
  then .
  else .[rowNum1] as $t
  | .[rowNum1] = .[rowNum2]
  | .[rowNum2] = $t
  end;

def toReducedRowEchelonForm:
   . as $in
   | length as $nr
   | (.[0]|length) as $nc
   | {a: $in, lead: 0 }
   | label $out
   | last(foreach range(0; $nr) as $r (.;
        if $nc <= .lead then ., break $out else . end
        | .i = $r
        | until( .a[.i][.lead] != 0 or .lead == $nc - 1;
            .i += 1
            | if $nr == .i
              then .i = $r
              | .lead += 1
	      else .
	      end
           )
        | swapRows(.i; $r)
        | if .a[$r][.lead] != 0
          then .a[$r][.lead] as $div
          | reduce range(0; $nc) as $j (.; .a[$r][$j] /= $div)
	  else .
	  end
        | reduce range(0; $nr) as $k (.;
            if $k != $r
            then .a[$k][.lead] as $mult
            | reduce range(0; $nc) as $j (.; .a[$k][$j] -= .a[$r][$j] * $mult)
            else .
	    end)
        | .lead += 1
	))
  | .a ;


# Assumption: the input is a square matrix with an inverse
# Uses the Gauss-Jordan method.
def inverse:
  . as $a
  | length as $nr
  | reduce range(0; $nr) as $i (
      matrix($nr; 2 * $nr; 0);
      reduce range( 0; $nr) as $j (.;
         .[$i][$j] = $a[$i][$j]
         | .[$i][$i + $nr] = 1 ))
  | last(toReducedRowEchelonForm)
  | . as $ary
  | reduce range(0; $nr) as $i ( matrix($nr; $nr; 0);
      reduce range($nr; 2 *$nr) as $j (.;
        .[$i][$j - $nr] = $ary[$i][$j] )) ;
