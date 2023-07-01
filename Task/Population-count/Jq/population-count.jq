def popcount:
  def bin: recurse( if . == 0 then empty else ./2 | floor end ) % 2;
  [bin] | add;

def firstN(count; condition):
  if count > 0 then
    if condition then ., (1+.| firstN(count-1; condition))
    else (1+.) | firstN(count; condition)
    end
  else empty
  end;

def task:
  def pow(n): . as $m | reduce range(0;n) as $i (1; . * $m);

  "The pop count of the first thirty powers of 3:",
   [range(0;30) as $n | 3 | pow($n) | popcount],

  "The first thirty evil numbers:",
   [0 | firstN(30; (popcount % 2) == 0)],

  "The first thirty odious numbers:",
   [0 | firstN(30; (popcount % 2) == 1)]
;

task
