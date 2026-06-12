# Generic stream-oriented min function
# Assume the stream s is not empty and does contain null
def min(s):
  reduce s as $x (null; if . == null then $x elif . < $x then . else $x end);

# Input: a string
# Assume 0 <= $n <= length
def rotate($n):
  .[$n:] + .[:$n];

# Emit the Lyndon word corresponding to the input string, else empty.
def lyndon:
  def circular:
    . as $in
    | any( range(1; length/2 + 1);  . as $n | $in | rotate($n) == .) ;

  if circular then empty
  else min(range(0;length) as $i | rotate($i))
  end;

# Input: a Lyndon word
# Output: the next Lyndon word relative to $alphabet
def nextWord($n; $alphabet):
  def a($i): $alphabet[$i:$i+1];
  ((($n/length)|floor + 1) * .)[:$n]
  | until (. == "" or .[-1:] != $alphabet[-1:]; .[:-1])
  | if . == "" then .
    else .[-1:] as $lastChar
    | ($alphabet|index($lastChar) + 1) as $nextCharIndex
    | .[0:-1] + a($nextCharIndex)
    end ;

def lyndon_words($n):
  . as $alphabet
  | .[:1]
  | while ( length <= $n and . != "";
      nextWord($n; $alphabet) ) ;

"01" | lyndon_words(5)
