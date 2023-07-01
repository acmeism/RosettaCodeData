def transpose:
  if (.[0] | length) == 0 then []
  else [map(.[0])] + (map(.[1:]) | transpose)
  end ;
