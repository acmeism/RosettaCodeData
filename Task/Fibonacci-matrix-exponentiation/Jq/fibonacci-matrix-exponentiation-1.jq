def mul($m1; $m2):
  ($m1|length) as $rows1
  | ($m1[0]|length) as $cols1
  | ($m2|length) as $rows2
  | ($m2[0]|length) as $cols2
  | if ($cols1 != $rows2) then "Matrices cannot be multiplied."| error
    else reduce range(0; $rows1) as $i (null;
      reduce range(0; $cols2) as $j (.;
        .[$i][$j] = 0
        | reduce range(0; $rows2) as $k (.;
           .[$i][$j] += $m1[$i][$k] * $m2[$k][$j])
	   ) )
    end ;

def identityMatrix:
  . as $n
  | [range(0; .) | 0] as $row
  | [range(0; .) | $row]
  | reduce range(0;$n) as $i (.;
      .[$i][$i] = 1 );

# . should be a square matrix and $n >= 0
def pow( $n ):
  . as $m
  | ($m|length) as $le
  | if $n < 0 then "Negative exponents not supported" | error
    elif $n == 0 then $le|identityMatrix
    elif $n == 1 then $m
    else {pow  : ($le | identityMatrix),
          base : $m,
          e    : $n }
    | until( .e <= 0.5;
    	   # debug|

        (.e % 2) as $temp
        | if $temp == 1 then .pow = mul(.pow; .base) else . end
        |  .e /= 2
        | .base = mul(.base; .base) )
    | .pow
    end;

def fibonacci:
  . as $n
  | if $n == 0 then 0
    else {m: [[1, 1], [1, 0]]}
    | .m |= pow($n - 1)
    | .m[0][0]
    end;

def task1:
  { i: 10 }
  | while ( .i <= 1e7;
      .n = .i
      | .s = (.n|fibonacci|tostring)
      | .i *= 10)
  | select(.s)
  | "\nThe digits of the \(.n)th Fibonacci number (\(.s|length)) are:",
    (if .s|length > 20
     then     "  First 20 : \(.s[0:20])",
     ( if (.s|length < 40)
       then "\n  Final \(.s|length-20): \(.s[20:])"
       else   "  Final 20 : \(.s[-20:])"
       end )
     else     "  All \(.s|length) : \(.s)"
     end) ;

def task2:
 pow(2;16) as $n
 | (($n|fibonacci)|tostring) as $s
 | "The digits of the 2^16th Fibonacci number \($s|length) are:",
   "  First 20 : \($s[0:20])",
   "  Final 20 : \($s[-20:])";

task1, "", task2
