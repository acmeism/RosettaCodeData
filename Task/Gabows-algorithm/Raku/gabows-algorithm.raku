# 20250415 Raku programming solution

my subset Vertex      of UInt;
my subset ComponentId of UInt;

class Digraph {
   has Int $.vertex-count is readonly;
   has Int $.edge-count is rw = 0;
   has     @.adjacency-lists;

   method new(Int $vertex-count where * >= 0) { # Constructor
      self.bless( vertex-count    => $vertex-count,
                  adjacency-lists => [ [] xx $vertex-count ] )
   }

   method add-edge(Vertex $from, Vertex $to) { # Add a directed edge
      self!validate-vertex($from);
      self!validate-vertex($to);
      @!adjacency-lists[$from].push($to);
      $!edge-count++;
   }

   method adjacency-list(Vertex $vertex) { # Get adjacency list for a vertex
      self!validate-vertex($vertex);
      @!adjacency-lists[$vertex];
   }

   method !validate-vertex(Vertex $vertex) { # Validate vertex index
      if $vertex >= $!vertex-count {
         die "Vertex $vertex is not between 0 and {$!vertex-count - 1}";
      }
   }

   method gist { # String representation
      return [~] [
         "Digraph has $!vertex-count vertices and $!edge-count edges\n",
         "Adjacency lists:\n"
      ].append( gather for ^$!vertex-count -> $vertex {
         take sprintf("%2d: ", $vertex);
         take @!adjacency-lists[$vertex].sort.Str ~ "\n"
      })
   }
}

class GabowSCC {
   has Bool   @.visited;
   has Int    @.component-ids; # Using Int with -1 as None equivalent
   has Int    @.preorders;     # Using Int with -1 as None equivalent
   has Int    $.preorder-count is rw = 0;
   has Int    $.scc-count is rw = 0;
   has Vertex @.visited-vertices-stack;
   has Vertex @.auxiliary-stack;

   method new(Digraph $digraph) { # Constructor
      my $n    = $digraph.vertex-count;
      my $self = self.bless(
         visited                => False xx $n,
         component-ids          => (-1) xx $n,
         preorders              => (-1) xx $n,
         visited-vertices-stack => [],
         auxiliary-stack        => []
      );

      for ^$n -> $vertex {
         $self!depth-first-search($digraph, $vertex) unless $self.visited[$vertex]
      }
      $self;
   }

   # Depth-first search for Gabow's algorithm
   method !depth-first-search(Digraph $digraph, Vertex $vertex) {
      @!visited[$vertex]   = True;
      @!preorders[$vertex] = $!preorder-count++;
      @!visited-vertices-stack.push($vertex);
      @!auxiliary-stack.push($vertex);

      for $digraph.adjacency-list($vertex).List -> $adjacent {
         if !@!visited[$adjacent] {
            self!depth-first-search($digraph, $adjacent)
         } else {
            if @!component-ids[$adjacent] == -1 {
               my $adjacent-preorder = @!preorders[$adjacent];
               while @!auxiliary-stack && @!preorders[@!auxiliary-stack[*-1]] > $adjacent-preorder {
                  @!auxiliary-stack.pop;
               }
            }
         }
      }

      if @!auxiliary-stack && @!auxiliary-stack[*-1] == $vertex {
         @!auxiliary-stack.pop;
         loop {
            my $scc-member = @!visited-vertices-stack.pop // die "Visited stack empty";
            @!component-ids[$scc-member] = $!scc-count;
            last if $scc-member == $vertex;
         }
         $!scc-count++;
      }
   }

   method get-component-id(Vertex $vertex) { # Get component ID for a vertex
       self!validate-vertex($vertex);
       @!component-ids[$vertex] == -1 ?? Nil !! @!component-ids[$vertex];
   }

   # Check if two vertices are strongly connected
   method is-strongly-connected(Vertex $v, Vertex $w) {
      self!validate-vertex($v);
      self!validate-vertex($w);
      @!component-ids[$v] != -1 && @!component-ids[$w] != -1 && @!component-ids[$v] == @!component-ids[$w];
   }

   method get-components() { # Get all components
      my @components = [] xx $!scc-count;
      for @!component-ids.kv -> $vertex, $id {
         if $id != -1 {
            $id < $!scc-count
               ?? @components[$id].push($vertex)
               !! note "Warning: Vertex $vertex has invalid SCC ID $id"
         }
      }
      @components.map: *.sort
   }

   method !validate-vertex(Vertex $vertex) { # Validate vertex index
      given my $n = @!visited.elems {
         die "Vertex $vertex is not between 0 and {$n - 1}" if $vertex >= $n
      }
   }
}

my @edges = [ <4 2>, <2 3>, <3 2>, <6 0>, <0 1>, <2 0>, <11 12>, <12 9>,
              <9 10>, <9 11>, <8 9>, <10 12>, <0 5>, <5 4>, <3 5>, <6 4>,
              <6 9>, <7 6>, <7 8>, <8 7>, <5 3>, <0 6>
            ].map: { ( from => .[0], to => .[1] ).Hash };
my $vertex-count = 13;
my $digraph = Digraph.new($vertex-count);

for @edges -> $edge { $digraph.add-edge($edge<from>, $edge<to>) }

print "Constructed digraph:" ~ $digraph.gist;

my $gabow-scc = GabowSCC.new($digraph);
say "It has $gabow-scc.scc-count() strongly connected components.";

my @components = $gabow-scc.get-components();
say "\nComponents:";
for @components.kv -> $i, @component {
   say "Component $i: " ~ @component.Str if @component.Bool;
}

say "\nExample connectivity checks:";
for ( <0 3>, <0 7>, <9 12> ) -> ($i,$j) {
   say "Vertices $i and $j strongly connected? {$gabow-scc.is-strongly-connected($i, $j)}"
}

say "Component ID of vertex 5: {$gabow-scc.get-component-id(5) // 'None'}";
say "Component ID of vertex 8: {$gabow-scc.get-component-id(8) // 'None'}";

(my $id = $gabow-scc.get-component-id(5)).defined
   ?? say "Component ID of vertex 5 (explicit handling): $id"
   !! say "Vertex 5 has no assigned component ID.";
