def cut($n):
def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;
nwise(80) | explode | reverse | implode
