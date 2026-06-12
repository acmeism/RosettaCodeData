# 20250710 Raku programming solution

constant MAX_SIZE = 2500;
constant EPSILON = 1e-8;

sub        is-equal($a, $b, :$eps = EPSILON) { abs($a - $b) < $eps }
sub is-greater-than($a, $b, :$eps = EPSILON) {    ($a - $b) > $eps }

class Vector {
   has Real ($.x, $.y, $.z) is rw;
   has  Int  $.id           is rw;

   method subtract(Vector $other) {
      Vector.new( :x($!x - $other.x), :y($!y - $other.y), :z($!z - $other.z) )
   }
   method cross-product(Vector $other) {
      Vector.new(
         x => $!y * $other.z - $!z * $other.y,
         y => $!z * $other.x - $!x * $other.z,
         z => $!x * $other.y - $!y * $other.x
      )
   }
   method dot-product(Vector $other) {
      $!x, $!y, $!z Z*+ $other.x, $other.y, $other.z # Seq
   }
   method magnitude { sqrt($!x² + $!y² + $!z²) }
   method equals(Vector $other) {
      all (($!x, $other.x),($!y,$other.y),($!z,$other.z)).map: { is-equal |$_ }
   }
   method gist { "Vector({$!x}, {$!y}, {$!z}, id={$!id})" }
}
class Line { has Vector ($.u, $.v) is rw }
class Plane {
   has Vector ($.u, $.v, $.w) is rw;
   method normal { $!v.subtract($!u).cross-product($!w.subtract($!u)) }
   method vector-at(Int $i) { ($!u, $!v, $!w)[$i] // Vector.new }
   method vector-id(Int $i) { self.vector-at($i).id }
}
class Facet {
   has Int $.id is rw = 0;
   has Int $.visited-time is rw = 0;
   has Bool $.is-deleted is rw = False;
   has Plane $.plane is rw;
   has @.neighbors is rw;
}
class Edge { has Int ($.net-id, $.face-id) is rw }

# Global state variables
my ( @facets, @hull-points, @edges, @visit-time, @queue );
my ( @res-facets-new, @res-facets-deleted, @res-points, $time-step );

# Geometric utilities
sub distance-point-plane(Vector $vec, Plane $plane) {
   $vec.subtract($plane.u).dot-product($plane.normal) / $plane.normal.magnitude
}
sub distance-point-line(Vector $vec, Line $line) {
   return 0 if my $length = $vec.subtract($line.u).magnitude == 0;
   $line.v.subtract($line.u).cross-product($vec.subtract($line.u)).magnitude /
   $line.v.subtract($line.u).magnitude
}
sub distance-point-point(Vector $a, Vector $b) { $a.subtract($b).magnitude }
sub is-above(Vector $point, Plane $plane) {
   is-greater-than($point.subtract($plane.u).dot-product($plane.normal), 0)
}

class ConvexHull3D {
   has Int         $.index is rw;
   has Real $.surface-area is rw = 0;

   method get-surface-area {
      return $!surface-area if is-greater-than($!surface-area, 0);
      $time-step++;
      self!dfs-area($!index);
      return $!surface-area
   }
   method !dfs-area(Int $facet-index) {
      return if @facets[$facet-index].visited-time == $time-step;

      @facets[$facet-index].visited-time = $time-step;
      $!surface-area += ( @facets[$facet-index].plane.normal ).magnitude / 2;

      do for ^3 -> $i { self!dfs-area(@facets[$facet-index].neighbors[$i]) }
   }
   method get-horizon(Int $facet-index, Vector $point, @res-deleted) {
      return 0 unless is-above($point, @facets[$facet-index].plane);
      return -1 if @facets[$facet-index].visited-time == $time-step;

      @facets[$facet-index].visited-time = $time-step;
      @facets[$facet-index].is-deleted = True;
      @res-deleted.push(@facets[$facet-index].id);

      my $result = -2;
      for 0..2 -> $neighbor-index {
         my $neighbor-facet-index = @facets[$facet-index].neighbors[$neighbor-index];
         my $horizon = self.get-horizon($neighbor-facet-index, $point, @res-deleted);

         if $horizon == 0 {
            my $a = @facets[$facet-index].plane.vector-id($neighbor-index);
            my $b = @facets[$facet-index].plane.vector-id(($neighbor-index + 1) % 3);

            for (0, 1) -> $idx {
               my $point-id = $idx == 0 ?? $a !! $b;
               my $neighbor-facet = $neighbor-facet-index;

               if @visit-time[$point-id] != $time-step {
                  @visit-time[$point-id] = $time-step;
                  @edges[0][$point-id].net-id = $idx == 0 ?? $b !! $a;
                  @edges[0][$point-id].face-id = $neighbor-facet;
               } else {
                  @edges[1][$point-id].net-id = $idx == 0 ?? $b !! $a;
                  @edges[1][$point-id].face-id = $neighbor-facet;
               }
            }
            $result = $a;
         } elsif $horizon != -1 && $horizon != -2 {
            $result = $horizon;
         }
      }
      return $result
   }
}

sub get-initial-hull(@points, Int $total-points) {
    # Find extreme points in each dimension
    my @extremes = @points[1] xx 6;

   for @points[1..$total-points] -> $point {
      @extremes[0] = $point if is-greater-than($point.x, @extremes[0].x);
      @extremes[1] = $point if is-greater-than(@extremes[1].x, $point.x);
      @extremes[2] = $point if is-greater-than($point.y, @extremes[2].y);
      @extremes[3] = $point if is-greater-than(@extremes[3].y, $point.y);
      @extremes[4] = $point if is-greater-than($point.z, @extremes[4].z);
      @extremes[5] = $point if is-greater-than(@extremes[5].z, $point.z);
   }
   # Find furthest pair
   my ($extreme0, $extreme1) = @extremes[0,1];
   for ^6 -> $i {
      for $i+1..^6 -> $j {
         my $distance = distance-point-point(@extremes[$i], @extremes[$j]);
         if is-greater-than($distance, distance-point-point($extreme0, $extreme1)) {
            ($extreme0, $extreme1) = @extremes[$i], @extremes[$j]
         }
      }
   }
   # Find furthest point from line
   my $line = Line.new(u => $extreme0, v => $extreme1);
   my $extreme2 = @extremes[0];
   for @extremes -> $point {
      if is-greater-than(distance-point-line($point, $line), distance-point-line($extreme2, $line)) {
         $extreme2 = $point;
      }
   }
   # Find furthest point from plane
   my $extreme3 = @points[1];
   my $base-plane = Plane.new(u => $extreme0, v => $extreme1, w => $extreme2);
   for 1..$total-points -> $i {
      my $dist1 = abs(distance-point-plane(@points[$i], $base-plane));
      my $dist2 = abs(distance-point-plane($extreme3, $base-plane));
      if is-greater-than($dist1, $dist2) { $extreme3 = @points[$i] }
   }
   # Ensure proper orientation
   if is-greater-than(0, distance-point-plane($extreme3, $base-plane)) {
      ($extreme1, $extreme2) = $extreme2, $extreme1;
   }
   # Create 4 initial facets
   my @facet-indices = ^4;
   for ^4 -> $i {
      @facets.push(Facet.new(id => @facets.elems));
      @facet-indices[$i] = @facets.end;
   }
   @facets[@facet-indices[0]].plane = Plane.new(u => $extreme0, v => $extreme2, w => $extreme1);
   @facets[@facet-indices[1]].plane = Plane.new(u => $extreme0, v => $extreme1, w => $extreme3);
   @facets[@facet-indices[2]].plane = Plane.new(u => $extreme1, v => $extreme2, w => $extreme3);
   @facets[@facet-indices[3]].plane = Plane.new(u => $extreme2, v => $extreme0, w => $extreme3);
   @facets[@facet-indices[0]].neighbors = [@facet-indices[3], @facet-indices[2], @facet-indices[1]];
   @facets[@facet-indices[1]].neighbors = [@facet-indices[0], @facet-indices[2], @facet-indices[3]];
   @facets[@facet-indices[2]].neighbors = [@facet-indices[0], @facet-indices[3], @facet-indices[1]];
   @facets[@facet-indices[3]].neighbors = [@facet-indices[0], @facet-indices[1], @facet-indices[2]];
   # Assign remaining points to facets
   for @points[1..$total-points] -> $point {
      next if any(($extreme0,$extreme1,$extreme2,$extreme3)>>.&{$point.equals($_)});
      for ^4 -> $j {
         if is-above($point, @facets[@facet-indices[$j]].plane) {
            @hull-points[@facet-indices[$j]].push($point);
            last;
         }
      }
   }
   return ConvexHull3D.new(index => @facet-indices[0])
}
sub quick-hull-Td(@points, Int $total-points) {
   my $hull = get-initial-hull(@points, $total-points);

   # Initialize processing queue
   @queue = [$hull.index];
   @queue.append(@facets[$hull.index].neighbors[^3]);

   my $new-horizon = 0;
   while @queue {
      my $next-facet-index = @queue.shift;
      if @facets[$next-facet-index].is-deleted || !@hull-points[$next-facet-index] {
         $new-horizon = $next-facet-index unless @facets[$next-facet-index].is-deleted;
         next;
      }
      # Find furthest point from current facet
      my $point = @hull-points[$next-facet-index][0];
      for @hull-points[$next-facet-index] -> $vec {
         if is-greater-than(distance-point-plane($vec, @facets[$next-facet-index].plane), distance-point-plane($point, @facets[$next-facet-index].plane)) {
            $point = $vec;
         }
      }
      # Find horizon
      $time-step++;
      @res-facets-deleted = ();
      my $horizon = $hull.get-horizon($next-facet-index, $point, @res-facets-deleted);
      # Build new faces around horizon
      $time-step++;
      my ($from, $last-facet-index, $first-facet-index) = -1 xx 3;

      while @visit-time[$horizon] != $time-step {
         @visit-time[$horizon] = $time-step;
         my ($net, $facet-index, $new-facet-index);

         if @edges[0][$horizon].net-id == $from {
            $net = @edges[1][$horizon].net-id;
            $facet-index = @edges[1][$horizon].face-id;
         } else {
            $net = @edges[0][$horizon].net-id;
            $facet-index = @edges[0][$horizon].face-id;
         }
         # Find indices on facet f
         my ($point-index1, $point-index2) = 0, 0;
         for ^3 -> $i {
            $point-index1 = $i if @points[$horizon].equals(@facets[$facet-index].plane.vector-at($i));
            $point-index2 = $i if @points[$net].equals(@facets[$facet-index].plane.vector-at($i));
         }
         ($point-index1, $point-index2) = $point-index2, $point-index1 if ($point-index1 + 1) % 3 != $point-index2;
         # Create new facet
         @facets.push(Facet.new(
            id    => @facets.elems,
            plane => Plane.new(
               u  => @facets[$facet-index].plane.vector-at($point-index2),
               v  => @facets[$facet-index].plane.vector-at($point-index1),
               w  => $point
            )
         ));
         $new-facet-index = @facets.end;
         @res-facets-new.push($new-facet-index);
         @facets[$new-facet-index].neighbors[0] = $facet-index;
         @facets[$facet-index].neighbors[$point-index1] = $new-facet-index;
         if $last-facet-index >= 0 { # Link with previous new facet
            if @facets[$new-facet-index].plane.vector-at(1).equals(@facets[$last-facet-index].plane.u) {
               @facets[$new-facet-index].neighbors[1] = $last-facet-index;
               @facets[$last-facet-index].neighbors[2] = $new-facet-index;
            } else {
               @facets[$new-facet-index].neighbors[2] = $last-facet-index;
               @facets[$last-facet-index].neighbors[1] = $new-facet-index;
            }
         } else {
            $first-facet-index = $new-facet-index;
         }
         ($last-facet-index, $from, $horizon) = $new-facet-index, $horizon, $net
      }
      # Close the loop
      if @facets[$first-facet-index].plane.vector-at(1).equals(@facets[$last-facet-index].plane.u) {
         @facets[$first-facet-index].neighbors[1] = $last-facet-index;
         @facets[$last-facet-index].neighbors[2] = $first-facet-index;
      } else {
         @facets[$first-facet-index].neighbors[2] = $last-facet-index;
         @facets[$last-facet-index].neighbors[1] = $first-facet-index;
      }
      # Collect points from deleted facets
      @res-points = gather for @res-facets-deleted -> $facet-id {
         take @hull-points[$facet-id];
         @hull-points[$facet-id] = [];
      }
      # Reassign points to new facets
      for @res-points -> $vec {
         next if $vec.equals($point);
         for @res-facets-new -> $facet-id {
            if is-above($vec, @facets[$facet-id].plane) {
               @hull-points[$facet-id].push($vec) and last
            }
         }
      }
      @queue.append(@res-facets-new); # Enqueue new faces for processing
   }
   $hull.index = $new-horizon;
   return $hull
}
                                  # Example: a tetrahedron
(my @points = Vector.new).append( # placeholder at index 0
   Vector.new(x => 0, y => 0, z => 0, id => 1),
   Vector.new(x => 1, y => 0, z => 0, id => 2),
   Vector.new(x => 0, y => 1, z => 0, id => 3),
   Vector.new(x => 0, y => 0, z => 1, id => 4)
);
say quick-hull-Td(@points, 4).get-surface-area.fmt('%.3f');
