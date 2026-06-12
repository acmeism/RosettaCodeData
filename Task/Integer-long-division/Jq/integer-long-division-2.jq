# To take advantage of gojq's support for accurate integer division:
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# If $m >= 0, $n > 0 then emit [ s, repetend ]
# where s is the string representation of $m/$n (possibly including trailing dots);
#       repetend is a string giving the repeating part of the decimal if any.
#
def integer_division($m; $n):
    if $m < 0 then "numerator must not be negative" | error
    elif $n <= 0 then "denominator must be positive" | error
    else ($m | idivide($n) | tostring + ".") as $quotient
    |  {c: (($m % $n) * 10), $quotient }
    | until (.c <= 0 or .c >= $n;  .c *= 10 | .quotient += "0")
    | . + { digits: "", passed: {}, i: 0, emit: false }
    | until (.emit;
        (.c | tostring) as $cs
        | if .passed|has($cs)
          then .quotient = .quotient + .digits[: .passed[$cs]]
	  | .emit = {quotient, repetend: .digits[.passed[$cs] :] }
          else .q = (.c | idivide($n))
          | .r = .c % $n
          | .passed[$cs] = .i
          | .digits += (.q|tostring)
          | .i += 1
          | .c = .r * 10
          end
          )
     end
     | .emit
     # move zeros from the tail of .repetend if possible
     | until ( .repetend[-1:] != "0" or .quotient[-1:] != "0";
              .quotient   |= .[:-1]
              | .repetend |= "0" + .[:-1] )
     | if .repetend != "0" and (.repetend|length > 0)
       then [.quotient + "(" + .repetend + ")", .repetend]
       else [(.quotient | sub("[.]$"; "")),
             (.repetend | if . == "0" then "" else . end)]
       end ;

def examples:
    [0, 1], [1, 1], [1, 3], [1, 7], [83,60], [1, 17], [10, 13], [3227, 555],
    [476837158203125, 9223372036854775808],
    [1, 149], [1, 5261]
;

def task:
  examples as [$a, $b]
  | (integer_division($a; $b)) as [$s, $r]
  |"\($a)/\($b) = \($s)",
    "Repetend is \($r)",
    "Period is \($r|length)\n" ;

task
