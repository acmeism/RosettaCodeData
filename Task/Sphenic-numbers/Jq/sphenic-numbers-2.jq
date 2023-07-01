# return an array, $a, of length .+1 or .+2 such that
# $a[$i] is $i if $i is prime, and false otherwise.
def primeSieve:
  # erase(i) sets .[i*j] to false for integral j > 1
  def erase(i):
    if .[i] then
      reduce range(2; (1 + length) / i) as $j (.; .[i * $j] = false)
    else .
    end;
  (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [null, null, range(2; $n)]
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i))
;
