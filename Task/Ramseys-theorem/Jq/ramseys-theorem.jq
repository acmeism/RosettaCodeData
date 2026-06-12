# Input: {a, idx} where .a is a connectivity matrix and
#   .idx is an array with length equal to the size of the group of interest.
# Assuming .idx[0] is 0, then depending on the value of $ctype,
# findGroup($ctype; 1; 1) will either find
# a completely connected or a uncompletely unconnected
# group of size `.idx|length` in .a, if it exists, or emit false.
# Set $ctype to 0 to find a completely unconnected group.
def findGroup($ctype; $min; $depth):
  . as $in
  | (.a|length) as $max
  | (.idx|length) as $size
  | if $depth == $size
    then (if $ctype == 0 then "un" else "" end) as $cs
    | "Totally \($cs)connected group: " + (.idx | map(tostring) | join(" "))
    else .i = $min
    | until (.i >= $max or .emit;
        .n = 0
        | until (.n >= $depth or .a[.idx[.n]][.i] != $ctype;
            .n += 1)
        | if .n == $depth
          then .idx[.n] = .i
          | .emit = findGroup($ctype; 1; $depth+1)
          else .
	  end
        | .i += 1 )
    | .emit // false
    end ;

# Output: {a, idx}
def init:
  def a:
    [range(0;17) | 0] as $zero
    | [range(0;17) | $zero]
    | reduce range(0;17) as $i (.; .[$i][$i] = 2);
  def idx: [range(0;4)|0];

  {a: a, idx: idx, k: 1}
  | until (.k > 8;
      reduce range(0;17) as $i (.;
        (($i + .k) % 17) as $j
        | .a[$i][$j] = 1
        | .a[$j][$i] = 1)
      | .k *= 2 )
  | del(.k);

# input: {a}
def printout:
  def mark(n): "01-"[n:n+1];
  .a as $a
  | range(0; $a|length) as $i
  | reduce range(0; $a|length) as $j (""; . + mark($a[$i][$j]) + " ") ;

# input: {a, idx}
def check:
  first( range(0; .a|length) as $i
      | .idx[0] = $i
      | findGroup(1; $i+1; 1) // findGroup(0; $i+1; 1) // empty
      |  . + "\nNo good.")
    // "All good." ;

init
| printout, check, "",
  # Test case breakage
  (  .a[2][1] = 0
   | .a[1][2] = 0
   | printout, check )
