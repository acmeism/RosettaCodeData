# Output: an array of the form [i^3 + j^3, [i, j]] sorted by the sum.
# Only cubes of 1 to ($in-1) are considered; the listing is therefore truncated
# as it might not capture taxicab numbers greater than $in ^ 3.
def sum_of_two_cubes:
  def cubed: .*.*.;
  . as $in
  | (cubed + 1) as $limit
  | [range(1;$in) as $i | range($i;$in) as $j

  | [ ($i|cubed) + ($j|cubed), [$i, $j] ] ] | sort
  | map( select( .[0] < $limit ) );

# Output a stream of triples [t, d1, d2], in order of t,
# where t is a taxicab number, and d1 and d2 are distinct
# decompositions [i,j] with i^3 + j^3 == t.
# The stream includes each taxicab number once only.
#
def taxicabs0:
  sum_of_two_cubes as $sums
  | range(1;$sums|length) as $i
  | if $sums[$i][0] == $sums[$i-1][0]
      and ($i==1 or $sums[$i][0] != $sums[$i-2][0])
    then [$sums[$i][0], $sums[$i-1][1], $sums[$i][1]]
    else empty
    end;

# Output a stream of $n taxicab triples: [t, d1, d2] as described above,
# without repeating t.
def taxicabs:
  # If your jq includes until/2 then the following definition
  # can be omitted:
  def until(cond; next):
    def _until: if cond then . else (next|_until) end;  _until;
  . as $n
  | [10, ($n / 10 | floor)] | max as $increment
  | [20, ($n / 2 | floor)] | max
  | [ ., [taxicabs0] ]
  | until( .[1] | length >= $m; (.[0] + $increment) | [., [taxicabs0]] )
  | .[1][0:$n] ;
