# input: a string
# output: a stream of runs
def runs:
  def init:
    explode as $s
    | $s[0] as $i
    | (1 | until( $s[.] != $i; .+1));
  if length == 0 then empty
  elif length == 1 then .
  else init as $n | .[0:$n], (.[$n:] | runs)
  end;

"gHHH5YY++///\\" | [runs] | join(", ")
