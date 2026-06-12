# 20250617 Raku programming solution

my $n = 5;                   # Number of vertices
my @adj = SetHash.new xx $n; # adjacency list

for ^$n -> $i {              # Add all edges except the edge (0,1)
   for $i+1 ..^$n -> $j {
      next if $i == 0 && $j == 1;
      @adj[$i].set($j);
      @adj[$j].set($i);
   }
}
say "Degrees of original graph: ";
for @adj.keys { say " deq($_) = {@adj[$_].elems}" }

# Compute the Chvátal closure
# iteratively add edges between non-adjacent vertices if degree-sum >= n
my @closure = @adj.map: { SetHash.new: | .keys };

my $added = True; # Clone original adjacency into @closure
while $added {
   $added = False;
   OUTER_LOOP: for ^$n -> $i {
      for $i+1 ..^$n -> $j {
          if ( !@closure[$i]{$j} && ( [+] @closure[$i,$j]>>.elems ) >= $n ) {
            @closure[$i].set: $j;
            @closure[$j].set: $i;
            $added = True;
            last OUTER_LOOP
         }
      }
   }
}

say "Adjacency list after closure:";
for ^$n -> $i { say "$i: ", @closure[$i].keys.sort.Str }

my $is-complete = (@closure>>.elems).all == ($n - 1); # check for completeness
say "Closure graph is{ $is-complete ?? ' ' !! ' not ' }complete.";


# If closure is complete, search for a Hamiltonian cycle in the original graph
if $is-complete { # Backtracking to find a cycle starting and ending at 0
   my @orig = @adj;              # use the original adjacency
   my @visited = False xx $n;    # visited flags
   my @path = (0);               # start path at vertex 0
   @visited[0] = True;
   my @cycle;

   sub dfs($curr) {
      return if @cycle.elems; # already found

      if @path.elems == $n { # If path has n vertices, check edge back to start
         if @orig[$curr]{@path[0]} { (@cycle = @path).push: @path[0] }
         return
      }

      for @orig[$curr].keys.sort -> $nbr { # Try all neighbors of $curr
         next if @visited[$nbr];
         @visited[$nbr] = True;
         @path.push: $nbr;
         dfs($nbr);
         @path.pop;
         @visited[$nbr] = False;
         return if @cycle.elems;  # stop if found
      }
   }(0);

   say @cycle.elems.Bool
      ?? "Hamiltonian cycle in original graph: {@cycle.join(' -> ')}"
      !! "No Hamiltonian cycle found in the original graph."
}
