# Emit a stream consisting of arrays, a, of $n items from the input array,
# preserving order, subject to (a|add) == $sum
def take($n; $sum):
  def take:
    . as [$m, $in, $s]
    | if $m==0 and $s == 0 then []
      elif $m==0 or $s <= 0 then empty
      else range(0;$in|length) as $i
      | $in[$i] as $x
      | if $x > $s then empty
        else [$x] + ([$m-1, $in[$i+1:], $s - $x] | take)
        end
      end;
  [$n, ., $sum] | take;
