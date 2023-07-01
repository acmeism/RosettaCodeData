# The index origin is 0 in jq.

def equilibrium_indices:
  . as $in
  | add as $add
  | foreach range(0;length) as $i (
      [0, 0, $add];  # [before, pivot, after]
      $in[$i] as $x | [.[0]+.[1], $x, .[2] - $x];
      if .[0] == .[2] then $i else empty end) ;
