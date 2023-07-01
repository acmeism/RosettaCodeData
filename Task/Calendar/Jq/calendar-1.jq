def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def center(width):
  tostring
  | length as $l
  | ((width - $l)/2 | floor) as $k
  | (" " * $k) + . + (" " * (width - ($k+$l)));
