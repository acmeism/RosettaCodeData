def sum(s): reduce s as $x (0; .+$x);

# Emit all the polydivisibles in the form of an array of arrays
# such that the numbers in .[i] are the polydivisibles of length i+1
def polydivisible:
   def extend($n):
     ((. * 10) + range(0;10)) | select(. % $n == 0);
   # input: an array of arrays, such that the numbers in .[i] are the polydivisibles of length i+1
   def extend:
     . as $in
     | length as $n
     | [$in[-1][] | extend($n+1)] as $x
     | if $x|length == 0 then $in
       else $in + [$x] | extend
       end;
   [[range(1;10)]] | extend;

def pandigital:
  tostring | gsub("0";"") | explode | unique | length == 9;

# Select the pandigitals from .[$k]
# Input: an array as produced by polydivisible
# Output: an array
def pd($k):
  .[$k] | map(select(pandigital));

def tasks:
  polydivisible
  | .[0] += [0]
  | "There are \(sum(.[] | length)) magic numbers in total.",
    "\nThe largest is \(.[-1][-1])",
    "\nThere are:",
      (range(0; length) as $i
       | "\(.[$i]|length) with \($i + 1) digit\(if ($i == 0) then "" else "s" end)"),
    ( "\nAll magic numbers that are pan-digital in 1 through 9 with no repeats: ",  pd(8)[] ),
    ( "\nAll magic numbers that are pan-digital in 0 through 9 with no repeats: ", pd(9)[] ) ;

tasks
