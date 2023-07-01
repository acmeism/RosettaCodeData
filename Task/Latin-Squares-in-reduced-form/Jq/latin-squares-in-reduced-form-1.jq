def count(s): reduce s as $x (0; .+1);

def factorial: reduce range(2;.+1) as $i (1; . * $i);

def permutations:
  if length == 0 then []
  else
    range(0;length) as $i
    | [.[$i]] + (del(.[$i])|permutations)
  end ;
