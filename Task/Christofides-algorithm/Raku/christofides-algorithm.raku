# 20250626 Raku programming solution

# --- Helper Classes ---

class Point { has ($.x, $.y, $.id);
   method new($x, $y, $id) { self.bless(:$x, :$y, :$id) }
}

class Edge { has ($.u, $.v, $.weight);
   method new($u, $v, $weight) { self.bless(:$u, :$v, :$weight) }
   method gist() { "({$.u}, {$.v}, {$.weight.fmt('%.2f')})" }
}

# --- Helper Functions for Printing ---

sub print-container(@container,$name) { say "$name: [{@container.join(', ')}]" }

sub print-edges(@edges,$name) { say "$name: [{@edges.map(*.gist).join(', ')}]" }

# --- Euclidean Distance ---

sub get-length(Point $p1, Point $p2) { sqrt( ($p1.x-$p2.x)² + ($p1.y-$p2.y)² ) }

# --- Build Complete Graph (Adjacency Matrix) ---

sub build-graph(@data) {
   my ($n, @graph) = @data.elems;

   for ^$n -> $i { # Symmetric graph
      for $i ^..^ $n -> $j {
         (@graph[$i;$j], @graph[$j;$i]) = get-length(@data[$i], @data[$j]) xx 2
      }
   }
   return @graph
}

# --- Union-Find Data Structure ---

class UnionFind {
   has (@.parent, @.rank);

   method new($n) { self.bless: parent => ^$n, rank => 0 xx $n }

   method find($i) {
      return $i if @.parent[$i] == $i;
      return @.parent[$i] = self.find(@.parent[$i]) # Path compression
   }

   method unite($i, $j) {
      my ($root-i, $root-j) = self.find($i), self.find($j);
      if $root-i != $root-j { # Union by rank
         if @.rank[$root-i] < @.rank[$root-j] {
            @.parent[$root-i] = $root-j;
         } elsif @.rank[$root-i] > @.rank[$root-j] {
            @.parent[$root-j] = $root-i;
         } else {
            @.parent[$root-j] = $root-i;
            @.rank[$root-i]++;
         }
      }
   }
}

# --- Minimum Spanning Tree (Kruskal's Algorithm) ---

sub minimum-spanning-tree(@graph) {
   my $n = @graph.elems;
   return [] if $n == 0;

   my @edges = ( gather for ^$n -> $i {
      for $i ^..^$n -> $j {
         take Edge.new($i, $j, @graph[$i][$j])
      }
   } ).sort(*.weight);

   my ($uf, $edges-count, @mst) = UnionFind.new($n), 0;

   for @edges -> $edge {
      if $uf.find($edge.u) != $uf.find($edge.v) {
         @mst.push($edge);
         $uf.unite($edge.u, $edge.v);
         last if ++$edges-count == $n - 1;  # MST has n-1 edges
      }
   }
   return @mst
}

# --- Find Vertices with Odd Degree in MST ---

sub find-odd-vertices(@mst, $n) {
   my @degree;
   for @mst -> $edge { (@degree[$edge.u], @degree[$edge.v])>>++ }

   return gather for ^$n -> $i { unless @degree[$i] %% 2  { take $i } }
}

# --- Minimum Weight Matching (Greedy Heuristic) ---

sub minimum-weight-matching(@mst is copy, @graph, @odd-vertices is copy) {
   @odd-vertices .= pick(*); # Shuffle for randomness

   # Keep track of vertices already matched in this phase
   my @matched = False xx @graph.elems;

   for ^@odd-vertices.elems -> $i {
      my $v = @odd-vertices[$i];
      next if @matched[$v].Bool;  # Skip if already matched

      my $min-length = Inf;
      my $closest-u = -1;

      # Find the closest unmatched odd vertex
      for $i ^..^@odd-vertices.elems -> $j {
         my $u = @odd-vertices[$j];
         unless @matched[$u].Bool {  # Check if 'u' is available
            if @graph[$v][$u] < $min-length {
               ($min-length, $closest-u) = @graph[$v][$u], $u;
            }
         }
      }

      if $closest-u != -1 {
         # Add the matching edge to the MST list (now a multigraph)
         @mst.push(Edge.new($v, $closest-u, $min-length));
         @matched[$v, $closest-u] = True xx 2;  # Mark both as matched
      }
   }
   return @mst;
}

# --- Find Eulerian Tour (Hierholzer's Algorithm) ---

sub find-eulerian-tour(@matched-mst, $n) {
   return [] if @matched-mst.elems == 0;

   # Build adjacency list representation of the multigraph (MST + matching)
   # Each element will be a hash with neighbor and edge-ptr keys
   my (@adj, %edge-used) = [] xx $n - 1;

   for @matched-mst -> $edge {
      @adj[$edge.u].push({ neighbor => $edge.v, edge-ptr => $edge });
      @adj[$edge.v].push({ neighbor => $edge.u, edge-ptr => $edge });
      %edge-used{$edge} = False;
   }

   my (@tour, @current-path);

   # Start at any vertex with edges (e.g., the first vertex of the first edge)
   #my $start-node = @matched-mst[0].u;
   @current-path.push(my $start-node = @matched-mst[0].u);

   while @current-path.elems > 0 {
      my ($current-node, $found-edge) = @current-path[*-1], False;

      # Find an unused edge from the current node
      for 0..^@adj[$current-node].elems -> $idx {
         my $edge-info = @adj[$current-node][$idx];
         my ($neighbor, $edge-ptr) = $edge-info<neighbor>, $edge-info<edge-ptr>;
         unless %edge-used{$edge-ptr}.Bool {
            %edge-used{$edge-ptr} = True;  # Mark edge as used
            # Push neighbor onto stack and move to it
            @current-path.push($neighbor);
            $found-edge = True;
            last;  # Move to the neighbor
          }
      }
      # If no unused edge was found from currentNode, backtrack
      unless $found-edge.Bool { @tour.push: @current-path.pop }
   }
   return @tour.reverse # Reverse the tour
}

# --- Main TSP Function (Christofides Approximation) ---

sub tsp(@data) {
   my $n = @data.elems;
   return (0.0, [])            if $n == 0;
   return (0.0, [@data[0].id]) if $n == 1;

   my @G = build-graph(@data); # Build a graph

   # Build a minimum spanning tree
   my @MSTree = minimum-spanning-tree(@G);
   print-edges(@MSTree, "MSTree");

   # Find odd degree vertices
   my @odd-vertices = find-odd-vertices(@MSTree, $n);
   print-container(@odd-vertices, "Odd vertexes in MSTree");

   # Add minimum weight matching edges (using greedy heuristic)
   my @MSTree-with-matching = minimum-weight-matching(@MSTree, @G, @odd-vertices);
   print-edges(@MSTree-with-matching, "Minimum weight matching (MST + Matching Edges)");

   # Find an Eulerian tour in the combined graph
   my @eulerian-tour = find-eulerian-tour(@MSTree-with-matching, $n);
   print-container(@eulerian-tour, "Eulerian tour");

   # --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
   if @eulerian-tour.elems == 0 {
      say "Error: Eulerian tour could not be found.";
      return (-1.0, []);
   }

   my ($length, @visited, @path) = 0.0, False xx $n;
   @path.push(my $current = @eulerian-tour[0]);
   @visited[$current] = True;

   for 1..^@eulerian-tour.elems -> $i {
      unless @visited[ my $v = @eulerian-tour[$i] ].Bool {
         @path.push($v);
         @visited[$v] = True;
         $length += @G[$current][$v];  # Add distance from previous node in path
         $current = $v;                # Update current node in path
      }
   }

   # Add the edge back to the start
   $length += @G[$current][@path[0]];
   @path.push(@path[0]);  # Complete the cycle

   print-container(@path, "Result path");
   say "Result length of the path: {$length.fmt('%.2f')}";

   return ($length, @path);
}

my @data = [ # Input data matching the Go example
   <1380 939>, <2848 96>, <3510 1671>, <457 334>, <3888 666>, <984 965>,
   <2721 1482>, <1286 525>, <2716 1432>, <738 1325>, <1251 1832>, <2728 1698>,
   <3815 169>, <3683 1533>, <1247 1945>, <123 862>, <1234 1946>, <252 1240>,
   <611 673>, <2576 1676>, <928 1700>, <53 857>, <1807 1711>, <274 1420>,
   <2574 946>, <178 24>, <2678 1825>, <1795 962>, <3384 1498>, <3520 1079>,
   <1256 61>, <1424 1728>, <3913 192>, <3085 1528>, <2573 1969>, <463 1670>,
   <3875 598>, <298 1513>, <3479 821>, <2542 236>, <3955 1743>, <1323 280>,
   <3447 1830>, <2936 337>, <1621 1830>, <3373 1646>, <1393 1368>, <3874 1318>,
   <938 955>, <3022 474>, <2482 1183>, <3854 923>, <376 825>, <2519 135>,
   <2945 1622>, <953 268>, <2628 1479>, <2097 981>, <890 1846>, <2139 1806>,
   <2421 1007>, <2290 1810>, <1115 1052>, <2588 302>, <327 265>, <241 341>,
   <1917 687>, <2991 792>, <2573 599>, <19 674>, <3911 1673>, <872 1559>,
   <2863 558>, <929 1766>, <839 620>, <3893 102>, <2178 1619>, <3822 899>,
   <378 1048>, <1178 100>, <2599 901>, <3416 143>, <2961 1605>, <611 1384>,
   <3113 885>, <2597 1830>, <2586 1286>, <161 906>, <1429 134>, <742 1025>,
   <1625 1651>, <1187 706>, <1787 1009>, <22 987>, <3640 43>, <3756 882>,
   <776 392>, <1724 1642>, <198 1810>, <3950 1558>,
];

srand 123456; # deterministic output
tsp( @data.kv.map: -> $i, @point { Point.new: @point[0], @point[1], $i } )
