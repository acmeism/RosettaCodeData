# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# gojq does not currently define _nwise
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def printRows($m): _nwise($m) | map(lpad(5)) | join("");
