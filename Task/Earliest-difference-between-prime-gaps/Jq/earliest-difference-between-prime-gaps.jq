# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  (. % $j) as $mod
  | (. - $mod) / $j ;

def properfactors:
  . as $in
  | [2, $in, false]
  | recurse(
      . as [$p, $q, $valid, $s]
      | if $q == 1        then empty
        elif $q % $p == 0 then [$p, ($q|idivide($p)), true]
        elif $p == 2      then [3, $q, false, $s]
        else ($s // ($q | sqrt)) as $s
        | if ($p + 2) <= $s then [$p + 2, $q, false, $s]
          else [$q, 1, true]
          end
        end )
   | if .[2] and .[0] != $in then .[0] else empty end ;

def stream_of_primes:
  2, (range(3; infinite; 2) | if first(properfactors) // null then empty else . end);

# Emit a sequence of objects {gap, p, previous} starting with
# {"gap":2,"p":5,"previous":3}
# {"gap":6,"p":29,"previous":23}
# The stream of .previous values corresponds to the OEIS sequence https://oeis.org/A000230
# except that `gaps` starts with .previous equal to 3 because 5-3 is the first occurrence of 2.
def gaps:
  foreach stream_of_primes as $p (null;
    if . == null then { $p, next: 2 }
    else (.next|tostring) as $next
    | if .[$next] then .emit = .[$next] | del( .[$next] ) | .next += 2 else .emit = null end
    | .emit2 = null
    | ($p - .p) as $gap
    | .previous = .p
    | .p = $p
    | if $gap < .next then .
      else ($gap|tostring) as $s
      | if $gap == .next then .emit2 = {$gap, p, previous} | .next += 2 | del( .[$s] )
        elif .[$s] then .
        else .[$s] = {$gap, p, previous}
        end
      end
    end;
    if .emit then .emit else empty end,
    if .emit2 then .emit2 else empty end
    );

# Report $n results, one for each order of magnitude starting with 10
def earliest_difference($n):

  def report($gap):
    if (($gap.previous - .previous)|length) > .magnitude
    then .emit += [del(.emit) + {p: $gap.previous}]
    | .magnitude *= 10
    | report($gap)
    else .
    end;

  limit($n;
     foreach gaps as $gap (null;
       if . == null then {magnitude: 10, n:0, previous: $gap.previous }
       else .emit = null
       | .n += 1
       | report($gap)
       | .previous = $gap.previous
       end)
       |  select(.emit).emit[]);

earliest_difference(7)
