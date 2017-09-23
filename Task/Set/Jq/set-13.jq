def intersect:
 .[0] as $A  | .[1] as $B
 | ($A|length) as $al
  | ($B|length) as $bl
  | if $al == 0 or $bl == 0 then false
    else
      ($B | bsearch($A[0])) as $b
      | if $b >= 0 then true
        else [$A[1:], $B[- (1 + $b) :]] | intersect
        end
    end;
