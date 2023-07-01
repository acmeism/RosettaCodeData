# input should be a non-negative integer
def commatize:
  def digits: tostring | explode | reverse;
  [foreach digits[] as $d (-1; .+1;
     (select(. > 0 and . % 3 == 0)|44), $d)]     # "," is 44
  | reverse | implode  ;

def count(stream): reduce stream as $i (0; .+1);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;
