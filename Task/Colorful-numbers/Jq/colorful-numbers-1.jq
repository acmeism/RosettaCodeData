# Uncomment for gojq
# def _nwise($n):
#   def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
#   n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Generate a stream of the permutations of the input array.
def permutations:
  if length == 0 then []
  else
    range(0;length) as $i
    | [.[$i]] + (del(.[$i])|permutations)
  end ;
