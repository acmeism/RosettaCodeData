# _nwise is for gojq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

# Input: a string
# Output: a stream of strings
def chars: explode[] | [.] | implode;
