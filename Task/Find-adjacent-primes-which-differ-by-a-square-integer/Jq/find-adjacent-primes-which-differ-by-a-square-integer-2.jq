# Input is given to primes/0  - to determine the maximum prime to consider
# Output: stream of [$prime, $nextPrime]
def adjacentPrimesWhichDifferBySquare:
  def isSquare: sqrt | . == floor;

  foreach primes as $p ( {previous: null};
    .emit = null
    | if .previous != null
         and (($p - .previous) | isSquare)
      then .emit = [.previous, $p]
      else .
      end
      | .previous = $p;
      select(.emit).emit);

# Input is given to primes/0 to determine the maximum prime to consider.
# Gap must be greater than $gap
def task($gap):
  def l: lpad(6);
  "Adjacent primes under \(.) whose difference is a square > \($gap):",
   (adjacentPrimesWhichDifferBySquare
    | (.[1] - .[0]) as $diff
    | select($diff > $gap)
    | "\(.[1]|l) - \(.[0]|l) = \($diff|lpad(4))" ) ;

1E6 | task(36)
