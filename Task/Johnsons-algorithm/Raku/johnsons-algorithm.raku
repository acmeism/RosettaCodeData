# 20250614 Raku programming solution

class Edge { # Edge structure
   has Int ($.u, $.v);
   has Num $.weight;
}

sub bellman-ford(Int $num-vertices, @edges, Int $source) {
   my @dist = Inf xx $num-vertices;
   @dist[$source] = 0;

   for ^($num-vertices - 1) { # Relax edges V-1 times
      my $updated = False;
      for @edges -> $edge {
         if @dist[$edge.u] != Inf && @dist[$edge.u]+$edge.weight < @dist[$edge.v] {
            @dist[$edge.v] = @dist[$edge.u] + $edge.weight;
            $updated = True;
         }
      }
      last unless $updated;
   }

   for @edges -> $edge { # Check for negative cycles
      if @dist[$edge.u] != Inf && @dist[$edge.u] + $edge.weight < @dist[$edge.v] {
         say "Graph contains a negative weight cycle";
         return Nil;
      }
   }
   return @dist;
}

sub dijkstra(Int $num-vertices, %adj, Int $source, @h-values) {
   my @dist = Inf xx $num-vertices;
   @dist[$source] = 0;
   my @final-dist = Inf xx $num-vertices;

   my @pq = [[0, $source],]; # Priority queue: array of [distance, vertex] pairs
   my %visited;

   while @pq {
      # Sort by distance, then vertex index for stability
      @pq.sort({ $^a[0] <=> $^b[0] || $^a[1] <=> $^b[1] });
      my ($d, $u) = @pq.shift;

      # Skip if already processed or distance is outdated
      next if %visited{$u}:exists || $d > @dist[$u];

      %visited{$u} = True;

      if %adj{$u}:exists { # Relax edges
         for %adj{$u}.List -> ($v, $weight) {
            if @dist[$u] != Inf && @dist[$u] + $weight < @dist[$v] {
               @dist[$v] = @dist[$u] + $weight;
               @pq.push: [@dist[$v], $v] unless %visited{$v}:exists;
            }
         }
      }
   }

   for ^$num-vertices -> $i { # Finalize distances, updating even if previously set
      if @dist[$i] != Inf {
         @final-dist[$i] = @dist[$i] - @h-values[$source] + @h-values[$i];
      }
   }
   return @final-dist;
}

sub johnsons-algorithm(@graph) {
   my ($V, @original-edges) = @graph.elems;

   for ^$V X ^$V -> ($i, $j) { # Step 0: Build edge list
      my $weight = @graph[$i][$j];
      if $i == $j {
         if $weight != 0 {
            say "Warning: graph[$i][$i] is $weight, expected 0. Setting to 0."
         }
      } elsif $weight != Inf && $weight != 0 {
         @original-edges.push: Edge.new(u => $i, v => $j, weight => $weight.Num)
      }
   }

   my @augmented-edges = @original-edges; # Step 1: Create augmented graph
   for ^$V -> $i {
      @augmented-edges.push: Edge.new(u => $V, v => $i, weight => 0.Num);
   }

   my @h-values = bellman-ford($V + 1, @augmented-edges, $V); # Step 2: Run Bellman-Ford
   return Nil if @h-values ~~ Nil;

   @h-values = @h-values[^$V]; # Remove augmented vertex h-value

   my %reweighted-adj; # Step 3: Reweight edges
   for ^$V -> $u { %reweighted-adj{$u} = [] }
   for @original-edges -> $edge {
      if @h-values[$edge.u] == Inf || @h-values[$edge.v] == Inf {
         say "Warning: invalid h-values detected.";
      }
      my $reweight = $edge.weight + @h-values[$edge.u] - @h-values[$edge.v];
      %reweighted-adj{$edge.u}.push: [$edge.v, $reweight];
   }

   my @result = []; # Step 4: Run Dijkstra for each vertex
   for ^$V -> $u { @result[$u] = dijkstra($V, %reweighted-adj, $u, @h-values) }

   return @result;
}

my @graph = [ # Test case
   [0,    -5,   2,   3],
   [Inf,   0,   4, Inf],
   [Inf, Inf,   0,   1],
   [Inf, Inf, Inf,   0]
];

with johnsons-algorithm(@graph) {
   .say for @_
} else {
   say "Negative cycle detected in the graph."
}
