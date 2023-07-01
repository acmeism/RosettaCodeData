def powerset:
  if length == 0 then [[]]
  else .[0] as $first
    | (.[1:] | powerset)
    | map([$first] + . ) + .
  end;
