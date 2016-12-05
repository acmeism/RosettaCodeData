# Eliminate row i and row j
def except(i;j):
  reduce del(.[i])[] as $row ([]; . + [$row | del(.[j]) ] );

def det:
  def parity(i): if i % 2 == 0 then 1 else -1 end;
  if length == 1 and (.[0] | length) == 1 then .[0][0]
  else . as $m
    | reduce range(0; length) as $i
        (0; . + parity($i) * $m[0][$i] * ( $m | except(0;$i) | det) )
  end ;

def perm:
  if length == 1 and (.[0] | length) == 1 then .[0][0]
  else . as $m
    | reduce range(0; length) as $i
        (0; . + $m[0][$i] * ( $m | except(0;$i) | perm) )
  end ;
