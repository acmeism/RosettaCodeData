# Output: the stream of elements in the Recaman sequence, beginning with 0.
def recaman:
  0,
  foreach range(1; infinite) as $i ({used: {"0": true}, current: 0};
      (.current - $i) as $next
      | .current = (if ($next < 1 or .used[$next|tostring]) then $next + 2 * $i else $next end)
      | .used[.current|tostring] = true;
      .current );

# emit [.i, $x] for duplicated terms using IO==0
def duplicated(s):
  foreach s as $x ({used: {}, i: -1};
    .i += 1
    | ($x|tostring) as $xs
    | if .used[$xs] then .emit = [.i, $x] else .used[$xs] = true end;
    select(.emit) | .emit);

# Input: an integer, $required
# s: a stream of non-negative integers
# Output: the index of the item in the stream s at which the stream up to and including
# that item includes all integers in the closed interval [0 .. $required].
#
def covers(s):
  . as $required
  | first(foreach s as $x ( { i: -1, found: {}, nfound: 0};
            .i += 1
	    | ($x|tostring) as $xs
            | if .found[$xs] then .
	      elif $x <= $required
	      then .found[$xs] = true | .nfound += 1
	      | if .nfound > $required then .emit=.i else . end
	      else .
	      end;
            select(.emit).emit) );
