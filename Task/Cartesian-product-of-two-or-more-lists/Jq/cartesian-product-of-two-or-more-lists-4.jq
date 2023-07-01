def cartesians:
  if length <= 2 then products
  else .[0][] as $x
  | (.[1:] | cartesians) as $y
  | [$x] + $y
  end;
