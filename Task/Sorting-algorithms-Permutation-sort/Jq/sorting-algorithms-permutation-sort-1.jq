def permutations:
  if length == 0 then []
  else
    . as $in
    | range(0;length) as $i
    | ($in|del(.[$i])|permutations)
    | [$in[$i]] + .
  end ;
