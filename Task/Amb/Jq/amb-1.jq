def amb: .[];

def joins:
  (.[0][-1:]) as $left
  | (.[1][0:1]) as $right
  | if $left == $right then true else empty end;
