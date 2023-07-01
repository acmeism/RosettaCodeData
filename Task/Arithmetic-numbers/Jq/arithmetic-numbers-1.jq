# For the sake of gojq
def _nwise($n):
  def nw: if length <= $n then . else .[0:$n] , (.[$n:] | nw) end;
  nw;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
