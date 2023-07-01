# input should be a non-negative integer
def commatize:
  # "," is 44
  def digits: tostring | explode | reverse;
  [foreach digits[] as $d (-1; .+1;
     (select(. > 0 and . % 3 == 0)|44), $d)]
  | reverse | implode  ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
