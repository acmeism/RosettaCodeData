# A reminder to include the definition of `proper_divisors`
# include "proper_divisors" { search: "." };

# Input: an array, each of whose elements is treated as distinct.
# Output: a stream of arrays.
# If the items in the input array are distinct, then the items in the
# stream represent the items in the powerset of the input array.  If
# the items in the input array are sorted, then the items in each of
# the output arrays will also be sorted.  The lengths of the output
# arrays are non-decreasing.
def powersetStream:
  if length == 0 then []
  else .[0] as $first
    | (.[1:] | powersetStream)
    | ., ([$first] + . )
  end;

def isPractical:
  . as $n
  | if . == 1 then true
    elif . % 2 == 1 then false
    else [proper_divisors] as $divs
    | first(
        foreach ($divs|powersetStream) as $subset (
           {found: [],
           count:  0 };
           ($subset|add) as $sum
           | if $sum > 0 and $sum < $n and (.found[$sum] | not)
             then .found[$sum] = true
             | .count += 1
             | if (.count == $n - 1) then .emit = true
               else .
               end
  	   else .
	   end;
           select(.emit).emit) )
      // false
  end;

# Input: the upper bound of range(1,_) to consider (e.g. infinite)
# Output: a stream of the practical numbers, in order
def practical:
  range(1;.)
  | select(isPractical);

def task($n):
  ($n + 1 | [practical]) as $p
  | ("In the range 1 .. \($n) inclusive, there are \($p|length) practical numbers.",
     "The first ten are:", $p[0:10],
     "The last ten are:", $p[-10:] );

task(333),
(666,6666,66666
 | "\nIs \(.) practical? \(if isPractical then "Yes." else "No." end)" )
