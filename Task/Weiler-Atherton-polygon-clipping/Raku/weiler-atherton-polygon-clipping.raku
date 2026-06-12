# 20250802 Raku programming solution
class Point { has Int ($.x, $.y) is rw;

   method new(Int $x, Int $y) { self.bless(:$x, :$y) }

   method gist() { "Point($!x, $!y)" }

   method WHICH() { "$!x,$!y" }
}

class Line { has Point ($.start, $.end) is rw;

   method new(Point $start, Point $end) { self.bless(:$start, :$end) }
}

class Polygon { has Point @.points is rw;

    method new(@points) { self.bless(:@points) }
}

enum InterVertexType <InsideVertex OutsideVertex InIntersection OutIntersection>
;

class InterVertex {
   has InterVertexType $.type  is rw;
   has Point           $.point is rw;

   method new(InterVertexType $type, Point $point) { self.bless(:$type, :$point)}
   method get-point() { $!point }
}

sub get-first-in-intersection(@list) {
   for @list.kv -> $i, $vertex {
      return $vertex.get-point() if $vertex.type == InIntersection
   }
   return Nil;
}

enum PolyListOptionType <List InsidePoly None>;

class PolyListOption {
   has PolyListOptionType $.type              is rw;
   has InterVertex        @.inter-vertex-list is rw;
   has Point              @.points            is rw;

   method new(PolyListOptionType $type, @inter-vertex-list = (), @points = ()) {
      self.bless(:$type, :@inter-vertex-list, :@points);
   }
}

sub is-in-polygon(Point $point, Polygon $poly) { # ray casting
   my (\x, \y) = $point.x, $point.y;

   return ?( ( (|$poly.points, $poly.points[0]).rotor(2 => -1).grep: {
      my ((\xi, \yi), (\xj, \yj)) := (.[0].x, .[0].y), (.[1].x, .[1].y);
      (yi,yj).one > y and x < (xj - xi) * (y - yi) / (yj - yi) + xi
   } ).elems % 2 ) # True with odd number of crossings
}

# DistanceCmp compares Manhattan distances from a reference point
sub distance-cmp(Point $self, Point $first, Point $second) {
   my $dst-first  = abs($self.x - $first.x)  + abs($self.y - $first.y);
   my $dst-second = abs($self.x - $second.x) + abs($self.y - $second.y);

   return $dst-first <=> $dst-second
}

# IsInLine checks if a point lies on a line segment
sub is-in-line(Point $point, Line $line) {
   my $dxc = $point.x - $line.start.x;
   my $dyc = $point.y - $line.start.y;

   my $dxl = $line.end.x - $line.start.x;
   my $dyl = $line.end.y - $line.start.y;

   if ( my $cross = $dxc * $dyl - $dyc * $dxl ) != 0 { return False }

   return do if abs($dxl) >= abs($dyl) {
      $dxl > 0 ?? $line.start.x <= $point.x <= $line.end.x
               !!   $line.end.x <= $point.x <= $line.start.x;
   } else {
      $dyl > 0 ?? $line.start.y <= $point.y <= $line.end.y
               !!   $line.end.y <= $point.y <= $line.start.y;
   }
}

# GetIntersection finds the intersection point of two line segments
sub get-intersection(Line $self, Line $line) {
   my $line1-start = $self.start;
   my $line1-end   = $self.end;
   my $line2-start = $line.start;
   my $line2-end   = $line.end;

   my $den = ($line2-end.y - $line2-start.y) * ($line1-end.x - $line1-start.x) -
             ($line2-end.x - $line2-start.x) * ($line1-end.y - $line1-start.y);

   return Nil if $den == 0;

   my $a = $line1-start.y - $line2-start.y;
   my $b = $line1-start.x - $line2-start.x;

   my $num1 = ($line2-end.x - $line2-start.x) * $a - ($line2-end.y - $line2-start.y) * $b;
   my $num2 = ($line1-end.x - $line1-start.x) * $a - ($line1-end.y - $line1-start.y) * $b;

   my $aF = $num1 / $den;
   my $bF = $num2 / $den;

   return Nil if $aF < 0.0 || $aF > 1.0 || $bF < 0.0 || $bF > 1.0;

   return my $result = Point.new(
      $line1-start.x + ($aF * ($line1-end.x - $line1-start.x)).round,
      $line1-start.y + ($aF * ($line1-end.y - $line1-start.y)).round
   )
}

# IsClockwise determines if polygon vertices are ordered clockwise
sub is-clockwise(Polygon $poly) {
   return ( sum gather for ^$poly.points.elems -> $i {
      my $j = ($i + 1) % $poly.points.elems;
      take ($poly.points[$j].x - $poly.points[$i].x) * ($poly.points[$j].y + $poly.points[$i].y);
   } ) < 0
}

# GetReversed returns a polygon with reversed point order
sub get-reversed(Polygon $poly) { return Polygon.new($poly.points.reverse) }

# GetFirstOutsideVertexIndex finds the first vertex outside the clipping polygon
sub get-first-outside-vertex-index(Polygon $subject, Polygon $poly) {
   for $subject.points.kv -> $i, $point {
      return $i unless is-in-polygon($point, $poly)
   }
   return Nil;
}

# GetFirstInsideVertexIndex finds the first vertex inside the clipping polygon
sub get-first-inside-vertex-index(Polygon $subject, Polygon $poly) {
   for $subject.points.kv -> $i, $point {
      return $i if is-in-polygon($point, $poly)
   }
   return Nil;
}

# GetIntersectionsWithLine finds all intersections between a polygon and a line
sub get-intersections-with-line(Polygon $poly, Line $line, $cursor-inside is rw) {
   my @intersections;

   for ^$poly.points.elems -> $i {
      my $start        = $poly.points[$i];
      my $next-i       = ($i + 1) % $poly.points.elems;
      my $end          = $poly.points[$next-i];
      my $l            = Line.new($start, $end);
      my $intersection = get-intersection($l, $line);

      if all $intersection.defined,
             $intersection.WHICH ne $line.start.WHICH,
             $intersection.WHICH ne $line.end.WHICH,
             $intersection.WHICH ne $start.WHICH,
             $intersection.WHICH ne $end.WHICH {
         @intersections.push: $intersection
      }
   }

   # Sort intersections by distance from line start
   @intersections .= sort({ distance-cmp($line.start, $^a, $^b) });

   return gather for @intersections -> $x {
      take $cursor-inside ?? InterVertex.new(OutIntersection, $x)
                          !! InterVertex.new( InIntersection, $x);
      $cursor-inside = !$cursor-inside
   }
}

# GetInterVertexList creates a list of intersection vertices
sub get-inter-vertex-list(Polygon $subject, Polygon $poly) {
   my $subject-copy = $subject;
   if !is-clockwise($subject-copy) {
      $subject-copy = get-reversed($subject-copy);
   }

   my $cursor-inside = False;

   my $start-index = get-first-outside-vertex-index($subject-copy, $poly);
   if $start-index.defined {
      if get-first-inside-vertex-index($subject-copy, $poly) !~~ Any {
         my $all-inside = True;
         for $poly.points -> $point {
            if !is-in-polygon($point, $subject-copy) {
               $all-inside = False;
               last;
            }
         }
         return PolyListOption.new(InsidePoly, [], $poly.points) if $all-inside
      }

      my @result;
      for ^$subject-copy.points.elems -> $i-offset {
         my $i     = ($start-index + $i-offset) % $subject-copy.points.elems;
         my $start = $subject-copy.points[$i];

         # Check vertex
         if $i != $start-index && is-in-polygon($start, $poly) {
            @result.append: InterVertex.new(InsideVertex, $start)
         } else {
            @result.append: InterVertex.new(OutsideVertex, $start)
         }

         # Check intersection
         my $next-i = ($i + 1) % $subject-copy.points.elems;
         my $end    = $subject-copy.points[$next-i];
         my $line   = Line.new($start, $end);

         @result.append: get-intersections-with-line($poly, $line, $cursor-inside)
      }
      my $has-intersections = False; # Check if there are any intersections
      for @result -> $vertex {
         if $vertex.type == InIntersection || $vertex.type == OutIntersection {
            $has-intersections = True and last
         }
      }
      return $has-intersections ?? PolyListOption.new(List, @result)
                                !! PolyListOption.new(None)
   } else {
      return PolyListOption.new(InsidePoly, [], $subject.points);
   }
}

# CollectFromListResult represents the result of collecting from a list
class CollectFromListResult { has Point (@.points, $.last-point) is rw;

   method new(@points, Point $last-point) { self.bless(:@points, :$last-point) }
}

# CollectFromList collects points from an intersection vertex list
sub collect-from-list(@list, Point $start-point) {
   my $initial-vertex-not-found = True;
   my ($start-i, $end-i, $last-point);
   my $dont-skip = @list.elems > 0 && @list[0].get-point().WHICH eq $start-point.WHICH;

   my @points;
   my $i = 0;

   # Skip until InIntersection occurs, but include the InIntersection
   while $i < @list.elems && $initial-vertex-not-found && !$dont-skip {
      my $next = ($i + 1) % @list.elems;
      my $next-point = @list[$next];

      if $next-point.type == InIntersection || $next-point.type == OutIntersection {
         if $next-point.get-point().WHICH eq $start-point.WHICH {
            $start-i = $next;
            $initial-vertex-not-found = False;
            last;
         }
      }
      $i++;
   }
   # Collect points
   if !$initial-vertex-not-found || $dont-skip {
      $i = $start-i;
      my $continue-collecting = True;

      while $continue-collecting && $i < @list.elems {
         my $vertex = @list[$i];

         if $vertex.type == OutIntersection {
            $end-i = $i;
            $last-point = $vertex.get-point();
            $continue-collecting = False;
         } else {
            @points.push($vertex.get-point());
         }
         $i++;
      }
   }
   my $amount = $end-i - $start-i + 1;
   if $end-i >= $start-i && $start-i + $amount <= @list.elems {
      @list.splice($start-i, $amount);
   }
   if @points.elems > 0 && $last-point.defined {
      return CollectFromListResult.new(@points, $last-point);
   }
   return Nil;
}

# GetClipPolygon generates a clipped polygon from intersection lists
sub get-clip-polygon(@subject, @clip, Point $initial) {
   my @result;
   my $subject-as-list = True;
   my $start-point = $initial;
   my $end-point = @subject[@subject.end].get-point();

   while $initial.WHICH ne $end-point.WHICH {
      my $values = $subject-as-list
                      ?? collect-from-list(@subject, $start-point)
                      !! collect-from-list(@clip,    $start-point);

      if $values.defined {
         $end-point = $values.last-point;
         $start-point = $end-point;
         $subject-as-list = !$subject-as-list;
         @result.append: $values.points;
      } else {
         return Nil;
      }
   }

   if @result.elems > 0 { # Filter consecutive duplicate points
      my @filtered = @result[0],;
      for 1..^@result.elems -> $i {
         if @result[$i].WHICH ne @result[$i-1].WHICH {
            @filtered.push: @result[$i];
         }
      }
      return @filtered;
   }
   return Nil;
}

# GetClipPolygons generates multiple clipped polygons
sub get-clip-polygons(@subject, @clip) {
   return gather loop {
      my $start-point = get-first-in-intersection(@subject);
      if !$start-point.defined { last }

      my $poly = get-clip-polygon(@subject, @clip, $start-point);
      $poly.defined ?? take $poly !! last
   }
}

# Clip performs polygon clipping between two polygons
sub clip(Polygon $self, Polygon $other) {
   my $option       = get-inter-vertex-list($self, $other);
   my $other-option = get-inter-vertex-list($other, $self);

   if $option.type == List {
      my @subject-list = $option.inter-vertex-list;

      if $other-option.type == List {
         my @clip-list = $other-option.inter-vertex-list;
         return get-clip-polygons(@subject-list, @clip-list);
      } elsif $other-option.type == InsidePoly {
         return [$other-option.points,];
      } else { # None
         return Nil;
      }
   } elsif $option.type == InsidePoly {
      return [$option.points,];
   } else { # None
      return Nil;
   }
}

sub run-tests() { # runs test cases
   # Test IsInLine
   my $p = Point.new(5, 10);
   my $line = Line.new(Point.new(5, 5), Point.new(5, 20));
   my $result = is-in-line($p, $line);
   say "IsInLine test 1: {$result ?? 'PASS' !! 'FAIL'}";

   my $pF = Point.new(3, 4);
   my $lineF = Line.new(Point.new(5, 5), Point.new(5, 20));
   my $resultF = is-in-line($pF, $lineF);
   say "IsInLine test 2: {!$resultF ?? 'PASS' !! 'FAIL'}";

   # Test Clip
   my $poly = Polygon.new([
      Point.new(180, 420), Point.new(180, 120), Point.new(520, 120),
      Point.new(520, 420), Point.new(420, 420), Point.new(320, 220),
   ]);

   my $inter-polygon = Polygon.new([
      Point.new(60, 220), Point.new(330, 120), Point.new(410, 290),
      Point.new(80, 480), Point.new(280, 280),
   ]);

   my $polygons = clip($poly, $inter-polygon);
   if $polygons.defined && $polygons.elems > 0 {
      say "Clip test: PASS - Found {$polygons.elems} polygons";
      if $polygons[0].elems > 0 { # Print first polygon points
         say "First polygon points:";
         for @($polygons[0]) -> $p { say "  Point: ({$p.x}, {$p.y})" }
      }
   } else {
     say "Clip test: FAIL - No polygons found";
   }
}

run-tests();
