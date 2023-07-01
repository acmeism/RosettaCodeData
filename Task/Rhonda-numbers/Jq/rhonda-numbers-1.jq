def prod(s): reduce s as $_ (1; . * $_);

def sigma(s): reduce s as $_ (0; . + $_);

# If s is a stream of JSON entities that does not include null, butlast(s) emits all but the last.
def butlast(s):
  label $out
  | foreach (s,null) as $x ({};
     if $x == null then break $out else .emit = .prev | .prev = $x end)
  | select(.emit).emit;

def multiple(s):
  first(foreach s as $x (0; .+1; select(. > 1))) // false;

# Output: a stream of the prime factors of the input
# e.g.
#  2 | factors #=> 2
# 24 | factors #=> 2 2 2 3
def factors:
  . as $in
  | [2, $in, false]
  | recurse(
      . as [$p, $q, $valid, $s]
      | if $q == 1        then empty
        elif $q % $p == 0 then [$p, $q/$p, true]
        elif $p == 2      then [3, $q, false, $s]
        else ($s // ($q | sqrt)) as $s
        | if $p + 2 <= $s then [$p + 2, $q, false, $s]
          else [$q, 1, true]
          end
        end )
   | if .[2] then .[0] else empty end ;
