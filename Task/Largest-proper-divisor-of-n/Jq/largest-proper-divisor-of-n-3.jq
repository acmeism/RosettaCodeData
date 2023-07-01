# For neatness
def lpad($len):
  tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def nwise($n):
  def w: if length <= $n then . else .[:$n], (.[$n:]|w) end;
  w;

### The task
[range(1; 101) | largestpd]
| nwise(10) | map(lpad(2)) | join(" ")
