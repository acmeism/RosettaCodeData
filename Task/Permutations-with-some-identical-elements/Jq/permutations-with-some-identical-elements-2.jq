# Input: an array
# Output: a stream of arrays
def nwise($n):
  def w: if length <= $n then . else .[:$n], (.[$n:]|w) end;
  w;

def to_table:
  nwise(10) | join("  ");
