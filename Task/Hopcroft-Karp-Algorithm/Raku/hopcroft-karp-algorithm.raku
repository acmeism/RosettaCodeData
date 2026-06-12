# 20250708 Raku programming solution

# Edge record to represent graph edges
class Edge { has Int ($.from, $.to);
   method new(Int $from, Int $to) { self.bless(:$from, :$to) }
}

# BipartiteGraph class implementing the Hopcroft-Karp algorithm
class BipartiteGraph {
   has Int $.m;  # Number of vertices in left partition U
   has Int $.n;  # Number of vertices in right partition V
   has @.adj;    # Adjacency lists for vertices in U
   has @.pair-u; # Matching for vertices in U
   has @.pair-v; # Matching for vertices in V
   has @.levels; # Distance levels for BFS

   # Constants
   constant NIL = 0;
   constant INFINITY = Inf;

   method new(Int $m, Int $n where * > 0) {
      my @adj    =    [] xx ($m + 1);
      my @pair-u = (NIL) xx ($m + 1);
      my @pair-v = (NIL) xx ($n + 1);
      my @levels =   Inf xx ($m + 1);
      return self.bless(:$m, :$n, :@adj, :@pair-u, :@pair-v, :@levels);
   }

   method add-edge( Int $u where 1 <= * <= $.m, Int $v where  1 <= * <= $.n ) {
      return @!adj[$u].push: $v;
   }

   method hopcroft-karp-algorithm() returns Int {
      @!pair-u = (NIL) xx ($!m + 1); # Reset
      @!pair-v = (NIL) xx ($!n + 1); # Reset
      my Int $matching-size = 0;

      while self.breadth-first-search() {
         for 1..$!m -> $u {
            # Check if vertex u is free and can be part of an augmenting path
            $matching-size++ if @!pair-u[$u] == NIL and $.depth-first-search($u)
         }
      } # Continue until no more augmenting paths can be found
      return $matching-size
   }

   # BFS to find if augmenting paths exist and compute shortest path lengths
   method breadth-first-search() returns Bool {
      my @queue = gather for 1..$!m -> $u { # Initialize levels for vertices
         @!pair-u[$u] == NIL ?? ( @!levels[take $u] = 0   )
                             !! ( @!levels[$u] = INFINITY )
      }

      # NIL vertex level represents shortest augmenting path length
      @!levels[NIL] = INFINITY;

      # BFS traversal
      while my $u = @queue.shift {
         # Only process if this path could lead to a shorter augmenting path
         if @!levels[$u] < @!levels[NIL] {
            for @!adj[$u].list -> $v {
               my $matched-u = @!pair-v[$v];

               # If the matched vertex hasn't been visited yet
               if @!levels[$matched-u] == INFINITY {
                  @!levels[$matched-u] = @!levels[$u] + 1;
                  @queue.push($matched-u);
               }
            }
         }
      }
      return @!levels[NIL] != INFINITY; # true if an augmenting path was found
   }

   # DFS to find and construct augmenting paths
   method depth-first-search(Int $u) returns Bool {
      if $u != NIL {
         for @!adj[$u].list -> $v {
            my $matched-u = @!pair-v[$v];

            # Check if this edge is part of a shortest augmenting path
            if @!levels[$matched-u] == @!levels[$u] + 1 {
               # Recursively try to find augmenting path from matched vertex
               if self.depth-first-search($matched-u) {
                  (@!pair-v[$v], @!pair-u[$u]) = $u, $v; # Update matching
                  return True;
               }
            }
         }
         @!levels[$u] = INFINITY; # No augmenting path found through this vertex
         return False;
      }
      return True;
   }
}

# Test runner function
sub test-case(Int $test-num, Int $m, Int $n, @edges, Int $expected) returns Bool {
   my $graph = BipartiteGraph.new($m, $n);

   for @edges -> $edge { $graph.add-edge($edge.from, $edge.to) }

   my $result = $graph.hopcroft-karp-algorithm();
   say "Test $test-num: Result = $result, Expected = $expected";

   return True if $result == $expected;
   say "Test $test-num failed!";
   return False;
}

say "Running Hopcroft-Karp Algorithm Tests:";
my $success-count = 0;

# Test Case 1: Simple case
$success-count += test-case(1, 3, 5, [Edge.new(1, 4)], 1) ?? 1 !! 0;

# Test Case 2: Multiple edges
$success-count += test-case(
   2, 6, 6, [ Edge.new(1, 4), Edge.new(1, 5), Edge.new(5, 1) ], 2
) ?? 1 !! 0;

# Test Case 3: Complete bipartite graph K(3,3)
my @edges = gather for 1..3 X 1..3 -> ($i,$j) { take Edge.new($i,$j) };
$success-count += test-case(3, 3, 3, @edges, 3) ?? 1 !! 0;

# Test Case 4: No edges
$success-count += test-case(4, 2, 2, [], 0) ?? 1 !! 0;

# Test Case 5: Complex case
$success-count += test-case(
   5, 4, 4, [ Edge.new(1, 1), Edge.new(1, 3), Edge.new(2, 3),
              Edge.new(3, 4), Edge.new(4, 3), Edge.new(4, 2) ], 4
) ?? 1 !! 0;

say  $success-count == 5 ?? "All tests passed!\n"
                         !! "$success-count/5 tests passed.\n";

say "Running main execution with hard-coded input:";

my ($hardcoded-m, $hardcoded-n) = 4, 4;
my @hardcoded-edges = [ [1, 1], [1, 3], [2, 3], [3, 4], [4, 3], [4, 2] ];

my $graph = BipartiteGraph.new($hardcoded-m, $hardcoded-n);
say "Hard-coded graph dimensions: m=$hardcoded-m, n=$hardcoded-n, edges={@hardcoded-edges.elems}";
say "Adding hard-coded edges:";

for @hardcoded-edges -> [$u, $v] {
   say "  Adding edge: ($u, $v)";

   if 1 <= $u <= $hardcoded-m and 1 <= $v <= $hardcoded-n {
      $graph.add-edge($u, $v);
   } else {
      say "Warning: Skipping invalid edge ($u, $v) - indices out of range";
   }
}
say "\nMaximum matching size is $graph.hopcroft-karp-algorithm()";
