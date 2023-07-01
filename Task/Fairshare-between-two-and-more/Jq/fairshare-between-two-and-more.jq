# Using a "reverse array" representations of the integers base b (b>=2),
# generate an unbounded stream of the integers from [0] onwards.
# E.g. for binary: [0], [1], [0,1], [1,1] ...

def integers($base):
  def add1:
    [foreach (.[], null) as $d ({carry: 1};
     if $d then ($d + .carry ) as $r
     | if $r >= $base
       then {carry: 1, emit: ($r - $base)}
       else {carry: 0, emit: $r }
       end
     elif (.carry == 0) then .emit = null
     else .emit = .carry
     end;
  select(.emit).emit)];

  [0] | recurse(add1);

def fairshare($base; $numberOfTerms):
  limit($numberOfTerms;
        integers($base) | add | . % $base);

# The task:
(2,3,5,11)
| "Fairshare \((select(.>2)|"among") // "between") \(.) people: \([fairshare(.; 25)])"
