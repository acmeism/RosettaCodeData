# 20250515 Raku programming solution

class Result { has Int ( $.Cost, @.Tour ) }

# heldKarp solves the Traveling Salesman Problem using the Held–Karp algorithm (O(n^2·2^n)).
# @dist is an n×n matrix of pairwise distances.
# Returns a Result{minimumCost, tour}, where tour is a sequence of city indices
# starting and ending at 0.
sub heldKarp(@dist) {
   my $subsetCount = 2 ** ( my $n = @dist.elems );
   # dp[mask][j] = minimum cost to start at 0, visit exactly the cities in mask, and end at j
   my (@dp,@parents) := [[Inf xx $n] xx $subsetCount], [[-1 xx $n] xx $subsetCount];
   @dp[1][0] = 0; # Base case: mask = 1<<0, at city 0, cost = 0

   for ^$subsetCount -> $mask { # Build up dp table
      next if $mask +& 1 == 0; # City 0 must always be included
      for ^$n -> $j {
         next if $mask +& (1 +< $j) == 0;
         my $prevMask = $mask +^ (1 +< $j);
         for ^$n -> $k {
            next if $prevMask +& (1 +< $k) == 0;
            if ( my $cost = @dp[$prevMask;$k] + @dist[$k;$j] ) < @dp[$mask;$j] {
               ( @dp[$mask][$j], @parents[$mask][$j] ) = $cost, $k
            }
         }
      }
   }

   # Complete the tour by returning to city 0
   my ($fullMask, $minCost, $lastCity) = $subsetCount - 1, Inf, 0;

   for ^$n -> $j {
      if ( my $cost = @dp[$fullMask;$j] + @dist[$j;0] ) < $minCost {
         ( $minCost, $lastCity ) = $cost, $j
      }
   }

   # Reconstruct the optimal tour
   my ($mask, $curr, @tour) = $fullMask, $lastCity, ($lastCity);

   while @tour[0] != 0 {
      my $prev = @parents[$mask;$curr];
      $mask +^= 1 +< $curr;
      $curr = $prev;
      @tour.unshift($curr);
   }
   @tour.push(0); # append the start city, then return to start

   return Result.new(Cost => $minCost, Tour => @tour)
}

# Test case: 4 cities with symmetric distances
my @dist = [ <0 2 9 10>, <1 0 6 4>, <15 7 0 8>, <6 3 12 0> ];

given heldKarp(@dist) { say "Minimum tour cost: { .Cost }\nTour: { .Tour }" }
