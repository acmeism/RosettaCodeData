def prb: (now|tostring[-1:] | tonumber) % 2 == 0;

def balanced:
  if length==0 then true
  elif .[:1] == "]" then false
  else test("[[][]]") and (gsub("[[][]]"; "") | balanced)
  end;

def task($n):
  if $n%2 == 1 then null
  else
    (reduce range(0; $n) as $i ("";
      . + (if prb then "[" else "]" end) ))
  | "\(.): \(balanced)"
  end;

task(0),
task(2),
(range(0;10) | task(4))
