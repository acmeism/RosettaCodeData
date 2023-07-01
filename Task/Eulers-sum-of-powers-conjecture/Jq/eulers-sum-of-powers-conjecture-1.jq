# Search for y in 1 .. maxn (inclusive) for a solution to SIGMA (xi ^ 5) = y^5
# and for each solution with x0<=x1<=...<x3, print [x0, x1, x3, x3, y]
#
def sum_of_powers_conjecture(maxn):
  def p5: . as $in | (.*.) | ((.*.) * $in);
  def fifth: log / 5 | exp;

  # return the fifth root if . is a power of 5
  def integral_fifth_root: fifth | if . == floor then . else false end;

  (maxn | p5) as $uber
  | range(1; maxn) as $x0
  | ($x0 | p5) as $s0
  | if $s0 < $uber then range($x0; ($uber - $s0 | fifth) + 1) as $x1
    | ($s0 + ($x1 | p5)) as $s1
    | if $s1 < $uber then range($x1; ($uber - $s1 | fifth) + 1) as $x2
      | ($s1 + ($x2 | p5)) as $s2
        | if $s2 < $uber then range($x2; ($uber - $s2 | fifth) + 1) as $x3
          | ($s2 + ($x3 | p5)) as $sumx
	  | ($sumx | integral_fifth_root)
	  | if . then [$x0,$x1,$x2,$x3,.] else empty end
	  else empty
	  end
      else empty
      end
    else empty
    end ;
