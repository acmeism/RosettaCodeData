# Generate the hailstone sequence as a stream to save space (and time) when counting
def hailstone:
  recurse( if . > 1 then
              if . % 2 == 0 then ./2|floor else 3*. + 1 end
           else empty
           end );

def count(g): reduce g as $i (0; .+1);

# return [i, length] for the first maximal-length hailstone sequence where i is in [1 .. n]
def max_hailstone(n):
  # state: [i, length]
  reduce range(1; n+1) as $i
    ([0,0];
     ($i | count(hailstone)) as $l
     | if $l > .[1] then [$i, $l] else . end);
