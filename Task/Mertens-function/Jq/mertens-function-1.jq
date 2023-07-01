def sum(s): reduce s as $x (null; . + $x);

def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# input: an array
# output: number of crossings at $value
def count_crossings($value):
  . as $a
  | reduce range(0; length) as $i ({};
    if $a[$i] == $value
      then if $i == 0 or .prev != $value then .count += 1 else . end
      else .
      end
      | .prev = $a[$i] )
  | .count;
