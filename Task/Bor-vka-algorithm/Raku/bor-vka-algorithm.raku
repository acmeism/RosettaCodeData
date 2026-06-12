# 20250612 Raku programming solution

class Edge { has Int ( $.u, $.v, $.weight ) }

class Graph {
   has Int $.v;         # Number of vertices
   has Edge @.edges;    # List of Edge(s)

   method add-edge(Int $u, Int $v, Int $weight) {
      @.edges.push: Edge.new(:$u, :$v, :$weight)
   }

   method boruvka-mst {
      my @parent = ^$.v;
      my @rank = 0 xx $.v;
      my ($num-trees, $mst-weight) = $.v, 0;

      sub find($i) { # find the root of a set with path compression
         return $i == @parent[$i] ?? $i !! (@parent[$i] = find(@parent[$i]))
      }

      sub union($x, $y) { # union two sets by rank
         my ($x-root, $y-root) = (find($x), find($y));
         return if $x-root == $y-root;

         when @rank[$x-root] < @rank[$y-root] { @parent[$x-root] = $y-root }
         default {
            @parent[$y-root] = $x-root;
            @rank[$x-root]++ if @rank[$x-root] == @rank[$y-root];
         }
      }

      while $num-trees > 1 { # Boruvka's main loop
         my @cheapest;

         for @.edges -> $edge { # Find the cheapest edge for each connected
            my ($set1, $set2)  = $edge.u, $edge.v;
            ($set1, $set2) .= map(&find);
            next if $set1 == $set2;

            for $set1, $set2 -> $set {
               @cheapest[$set] //= $edge;
               @cheapest[$set] = $edge if $edge.weight < @cheapest[$set].weight
            }
         }

         for @cheapest.grep(*.defined) -> $edge {# Add the chosen cheapest edges
            my ($set1, $set2) = (find($edge.u), find($edge.v));
            next if $set1 == $set2;

            $mst-weight += $edge.weight;
            union($set1, $set2);
            say "Edge {$edge.u}→{$edge.v} with weight {$edge.weight} added to MST";
            $num-trees--
         }
      }
      say "Total MST weight: $mst-weight"
   }
}

my $graph = Graph.new(v => 4);
$graph.add-edge(|$_) for (0,1,10), (0,2,6), (0,3,5), (1,3,15), (2,3,4);
$graph.boruvka-mst;
