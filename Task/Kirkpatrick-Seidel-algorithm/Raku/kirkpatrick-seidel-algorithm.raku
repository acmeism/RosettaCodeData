# 20250705 Raku programming solution

class Point { has Num ($.x, $.y);

   method less-than(Point $other) {
      return self.x == $other.x ?? ( self.y < $other.y ) !! self.x < $other.x
   }

   method equals(Point $other) { self.x == $other.x && self.y == $other.y }

   method not-equals(Point $other) { return !self.equals($other) }

   method WHICH() { "{self.x},{self.y}".Str.WHICH }
}

sub flipped(@points) { @points.map: { Point.new(x => -$_.x, y => -$_.y) } }

sub quickselect( @ls is copy, Int $index, &less-than, Int $lo = 0, Int $hi = @ls.end) {
   return @ls[$lo] if $lo == $hi;

   my $pivot-index = $lo + floor(rand * ($hi - $lo + 1));
   my $pivot = @ls[$pivot-index];

   (@ls[$lo], @ls[$pivot-index]) = (@ls[$pivot-index], @ls[$lo]);

   my $cur = $lo;
   for $lo + 1 .. $hi -> $run {
      if less-than(@ls[$run], $pivot) {
         $cur++;
         (@ls[$cur], @ls[$run]) = (@ls[$run], @ls[$cur])
      }
   }

   (@ls[$cur], @ls[$lo]) = (@ls[$lo], @ls[$cur]);

   return do given ($index, $cur) {
      when $index < $cur { quickselect(@ls, $index, &less-than, $lo, $cur - 1) }
      when $index > $cur { quickselect(@ls, $index, &less-than, $cur + 1, $hi) }
      default            { @ls[$cur] }
   }
}

sub quickselect-float(@ls is copy, Int $index, Int $lo = 0, Int $hi = @ls.end) {
   quickselect(@ls, $index, -> $a, $b { $a < $b }, $lo, $hi)
}

sub quickselect-point(@ls is copy, Int $index, Int $lo = 0, Int $hi = @ls.end) {
   quickselect(@ls, $index, -> $a, $b { $a.less-than($b) }, $lo, $hi)
}

sub bridge(SetHash $points-set, Num $vertical-line) {
   if (my @points = $points-set.keys).elems == 2 { return @points[0,1] }

   my $candidates = SetHash.new;
   my @pairs;
   my @modifyS = @points;

   while @modifyS.elems >= 2 {
      my ($p1, $p2) = @modifyS.splice(0,2);
      @pairs.push: $p1.less-than($p2) ?? ($p1, $p2) !! ($p2, $p1)
   }

   if @modifyS.elems == 1 { $candidates{ @modifyS[0] } = True }

   my (@slopes, @valid-pairs);
   for @pairs -> ($pi, $pj) {
      if $pi.x == $pj.x {
         ( $pi.y > $pj.y ?? $candidates{ $pi } !! $candidates{ $pj } ) = True
      } else {
         @slopes.push: ($pi.y - $pj.y) / ($pi.x - $pj.x);
         @valid-pairs.push: ($pi, $pj);
      }
   }

   if @slopes.elems == 0 {
      return $candidates.elems >= 2 ?? $candidates.keys[0,1] !! @points[0,1]
   }

   my $median-index = @slopes.elems div 2 - (1 - @slopes.elems % 2);
   my @slopes-copy  = @slopes;
   my $median-slope = quickselect-float(@slopes-copy, $median-index);

   my (@small, @equal, @large);
   for @slopes.kv -> $i, $slope {
      given $slope <=> $median-slope {
         when Order::Less { @small.push(@valid-pairs[$i]) }
         when Order::Same { @equal.push(@valid-pairs[$i]) }
         when Order::More { @large.push(@valid-pairs[$i]) }
      }
   }

   my $max-slope = max $points-set.keys.map: { $_.y - $median-slope * $_.x };

   my @max-set = gather for $points-set.keys -> $p {
      take $p if $p.y - $median-slope * $p.x == $max-slope
   }
   my ($left, $right) = @max-set[0] xx 2;

   for @max-set -> $p {
      $left  = $p     if $p.less-than($left);
      $right = $p unless $p.less-than($right)
   }

   return $left, $right if $left.x <= $vertical-line && $right.x > $vertical-line;

   if $right.x <= $vertical-line {
      for @large -> ($pi, $pj) { $candidates{ $pj } = True  }
      for @equal -> ($pi, $pj) { $candidates{ $pj } = True  }
      for @small -> ($pi, $pj) { $candidates{ $pi } = True;
                                 $candidates{ $pj } = True; }
   }

   if $left.x > $vertical-line {
      for @small -> ($pi, $pj) { $candidates{ $pi } = True  }
      for @equal -> ($pi, $pj) { $candidates{ $pi } = True  }
      for @large -> ($pi, $pj) { $candidates{ $pi } = True;
                                 $candidates{ $pj } = True; }
   }
   return bridge($candidates, $vertical-line);
}

sub connect(Point $lower, Point $upper, SetHash $points-set) {
   return [$lower] if $lower.equals($upper);

   my @points-copy = my @points-vec = $points-set.keys;
   my $mid-index = @points-vec.elems div 2 - 1;
   my $max-left  = quickselect-point(@points-copy, $mid-index);
   @points-copy  = @points-vec;
   my $min-right = quickselect-point(@points-copy, $mid-index + 1);
   my ($left, $right) = bridge($points-set, ($max-left.x + $min-right.x) / 2);
   my $points-left = SetHash.new($left);
   my $points-right = SetHash.new($right);
   for $points-set.keys -> $p {
      if $p.x < $left.x {
         $points-left{ $p } = True;
      } elsif $p.x > $right.x {
         $points-right{ $p } = True;
      }
   }
   my @left-result  = connect($lower,  $left,  $points-left);
   my @right-result = connect($right, $upper, $points-right);

   return [|@left-result, |@right-result];
}

sub upper-hull(SetHash $points-set) {
   my @points = $points-set.keys;
   my $lower = @points[0];
   for @points -> $p {
      $lower = $p if $p.x < $lower.x || ($p.x == $lower.x && $p.y < $lower.y)
   }
   for @points -> $p { $lower = $p if $p.x == $lower.x && $p.y > $lower.y }

   my $upper = @points[0];
   for @points -> $p {
      $upper = $p if $p.x > $upper.x || ($p.x == $upper.x && $p.y > $upper.y)
   }

   my $filtered-points = SetHash.new($lower, $upper);
   for @points -> $p {
      $filtered-points{ $p } = True if $lower.x < $p.x < $upper.x
   }
   return connect($lower, $upper, $filtered-points);
}

sub convex-hull(SetHash $points-set) {
   my @upper = upper-hull($points-set);

   my $flipped-points = SetHash.new;
   for $points-set.keys -> $p {
      $flipped-points{ Point.new(x => -$p.x, y => -$p.y) } = True;
   }

   my @flipped-upper = upper-hull($flipped-points);
   my @lower = flipped(@flipped-upper);

   @upper = @upper[0..*-2] if @upper && @lower && @upper[*-1].equals(@lower[0]);

   @lower = @lower[0..*-2] if @upper && @lower && @upper[0].equals(@lower[*-1]);

   return [|@upper, |@lower];
}

srand time;
my $points = SetHash.new(
   Point.new(x => 0e0, y => 0e0),
   Point.new(x => 1e0, y => 0e0),
   Point.new(x => 0e0, y => 1e0),
   Point.new(x => 0.5e0, y => 0.5e0)
);

say "Input points:";
for $points.keys -> $p { printf("(%.6f, %.6f)\n", $p.x, $p.y) }

my @hull = convex-hull($points).Set.keys.sort(
              -> $a, $b { $a.x <=> $b.x || $a.y <=> $b.y });
say "\nConvex hull points:";
for @hull -> $p { printf("(%.6f, %.6f)\n", $p.x, $p.y) }
