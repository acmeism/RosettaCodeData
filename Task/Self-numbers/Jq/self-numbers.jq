def sumdigits: tostring | explode | map([.]|implode|tonumber) | add;

def gsum: . + sumdigits;

def isnonself:
  def ndigits: tostring|length;
  . as $i
  | ($i - ($i|ndigits)*9) as $n
  | any( range($i-1; [0,$n]|max; -1);
          gsum == $i);

# an array
def last81:
  [limit(81; range(1; infinite) | select(isnonself))];

# output an unbounded stream
def selfnumbers:
  foreach range(1; infinite) as $i ( [0, last81];
    .[0] = false
    | .[1] as $last81
    | if $last81 | bsearch($i) < 0
      then .[0] = $i
      | if $i > $last81[-1] then .[1] = $last81[1:] + [$i | gsum ] else . end
      else .
      end;
      .[0] | select(.) );


"The first 50 self numbers are:", last81[:50],
"",
(nth(100000000 - 1;  selfnumbers)
 | if . == 1022727208
   then "Yes, \(.) is the 100,000,000th self number."
   else "No,  \(.i) is actually the 100,000,000th self number."
   end)
