# generate octals as strings, beginning with "0"
def octals:
  # input and output: array of octal digits in reverse order
  def octal_add1:
    [foreach (.[], null) as $d ({carry: 1};
     if $d then ($d + .carry ) as $r
     | if $r > 7
       then {carry: 1, emit: ($r - 8)}
       else {carry: 0, emit: $r }
       end
     elif (.carry == 0) then .emit = null
     else .emit = .carry
     end;
  select(.emit).emit)];

  [0] | recurse(octal_add1) | reverse | join("");

octals
