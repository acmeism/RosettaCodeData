def lpad($len; $fill): tostring | ($len - length) as $l | ($fill * $l)[:$l] + .;

def lpad($len): lpad($len; " ");

# Like *ix `tr` but it is as though $to is padded with blanks
def tr($from;$to):
  explode as $s
  | ($from | explode) as $f
  | ($to   | explode) as $t
  | reduce range(0;length) as $i ([];
      ($f | index($s[$i])) as $ix
      | if $ix then . + [$t[$ix] // " "]
        else . + [$s[$i]]
	end )
  | implode;	

# Input: a non-negative integer
# Output: the corresponding stream of bits (0s and 1s),
# least significant digit first, with a final 0
def stream:
  recurse(if . > 0 then ./2|floor else empty end) | . % 2 ;

# input: an array, e.g. as produced by [7|stream]
# output: the corresponding binary string
def to_b: reverse | map(tostring) | join("") | sub("^0";"");
