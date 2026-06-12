# 20200427 Raku programming solution

class AStarGraph {

   has @.barriers =
      <2 4>,<2 5>,<2 6>,<3 6>,<4 6>,<5 6>,<5 5>,<5 4>,<5 3>,<5 2>,<4 2>,<3 2>;

   method heuristic(\start, \goal) {
      my (\D1,\D2) = 1, 1;
      my (\dx,\dy) = ( start.list »-« goal.list )».abs;
      return  (D1 * (dx + dy)) + (D2 - 2*D1) * min dx, dy
   }

   method get_vertex_neighbours(\pos) {
      gather {
         for <1 0>,<-1 0>,<0 1>,<0 -1>,<1 1>,<-1 1>,<1 -1>,<-1 -1> -> \d {
            my (\x2,\y2) = pos.list »+« d.list;
            (x2 < 0 || x2 > 7 || y2 < 0 || y2 > 7) && next;
            take x2, y2;
         }
      }
   }

   method move_cost(\a,\b) { (b ~~ any self.barriers) ?? 100 !! 1 }
}

sub AStarSearch(\start, \end, \graph) {

   my (%G,%F);

   %G{start.Str} = 0;
   %F{start.Str} = graph.heuristic(start, end);

   my @closedVertices = [];
   my @openVertices = [].push(start);
   my %cameFrom;

   while (@openVertices.Bool) {
      my $current = Nil; my $currentFscore = Inf;

      for @openVertices -> \pos {
         if (%F{pos.Str} < $currentFscore) {
            $currentFscore = %F{pos.Str};
            $current = pos
         }
      }

      if $current ~~ end {
         my @path = [].push($current);
         while %cameFrom{$current.Str}:exists {
            $current = %cameFrom{$current.Str};
            @path.push($current)
         }
         return @path.reverse, %F{end.Str}
      }

      @openVertices .=  grep: * !eqv $current;
      @closedVertices.push($current);

      for (graph.get_vertex_neighbours($current)) -> \neighbour {
         next if neighbour ~~ any @closedVertices;
         my \candidateG = %G{$current.Str}+graph.move_cost($current,neighbour);

         if !(neighbour ~~ any @openVertices) {
            @openVertices.push(neighbour)
         } elsif (candidateG ≥ %G{neighbour.Str}) {
            next
         }

         %cameFrom{neighbour.Str} = $current;
         %G{neighbour.Str} = candidateG;
         my \H = graph.heuristic(neighbour, end);
         %F{neighbour.Str} = %G{neighbour.Str} + H;
      }
   }
   die "A* failed to find a solution"
}

my \graph = AStarGraph.new;
my (\route, \cost) = AStarSearch(<0 0>, <7 7>, graph);

my \w = my \h = 10;

my @grid = [ ['.' xx w ] xx h ];
for ^h -> \y { @grid[y;0] = "█"; @grid[y;*-1] = "█" }
for ^w -> \x { @grid[0;x] = "█"; @grid[*-1;x] = "█" }

for (graph.barriers) -> \d { @grid[d[0]+1][d[1]+1] = "█" }
for @(route)         -> \d { @grid[d[0]+1][d[1]+1] = "x" }

.join.say for @grid ;

say "Path cost : ", cost, " and route : ", route;
