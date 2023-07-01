def if2(c1; c2; both; first; second; neither):
  c1 as $c1
  | c2 as $c2
  | if $c1 and $c2 then both
    elif $c1 then first
    elif $c2 then second
    else neither
    end;
