# Emit a stream of consecutive primes.
# The stream is unbounded if . is null or infinite,
# otherwise it continues up to but excluding `.`.
def primes:
  (if . == null then infinite else . end) as $n
  | 2, (range(3; $n; 2) | select(is_prime));

# s is a stream
# $deltas is an array
# Output: a stream of arrays, each corresponding to a selection of consecutive
# items from s satisfying the differences requirement.
def filter_differences(s; $deltas):

  def diffs_equal: # i.e. equal to $deltas
    . as $in
    | all( range(1;length);
           ($in[.] - $in[.-1]) == $deltas[. - 1]);

  ($deltas|length + 1) as $n
  | foreach s as $x ( {};
      .emit = null
      | .tuple += [$x]
      | .tuple |= .[-$n:]
      | if (.tuple|length) == $n
        then if (.tuple|diffs_equal) then .emit = .tuple
             else .
	     end
	else .
	end;
      select(.emit).emit );

def report_first_last_count(s):
  null | {first,last,count}
  | reduce s as $x (.;
      if .first == null then .first = $x else . end
      | .count = .count + 1
      | .last = $x ) ;
