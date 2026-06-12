class P { has ($.x, $.y) is rw;                # Point
   method gist { "({$.x~", "~$.y})" }
}

class C { has (P $.c, Numeric $.r);            # Circle
   method gist { "Center = " ~$.c.gist ~ " and Radius = $.r\n" }

   # tests whether a circle contains the point 'p'
   method contains(P \p --> Bool) { distSq($.c, p) ≤ $.r² }

   # tests whether a circle contains a slice of point
   method encloses(@ps --> Bool) { [and] @ps.map: { $.contains($_) } }
}

sub infix:<−> (P \a, P \b) { a.x - b.x, a.y - b.y } # note: Unicode 'minus'

# returns the square of the distance between two points
sub distSq (P \a, P \b) { [+] (a − b)»² }

sub getCenter (\bx, \by, \cx, \cy --> P) {
   my (\b,\c,\d) = bx²+by², cx²+cy², bx*cy - by*cx;
   P.new: x => (cy*b - by*c) / (2 * d), y => (bx*c - cx*b) / (2 * d)
} # returns the center of a circle defined by 3 points

sub circleFrom3 (P \a, P \b, P \c --> C)  {
   my \k = $ = getCenter |(b − a), |(c − a);
   k.x, k.y Z[+=] a.x, a.y;
   C.new: c => k, r => distSq(k, a).sqrt
} # returns a unique circle that intersects 3 points

sub circleFrom2 (P \a, P \b --> C ) {
   my \center = P.new: x => ((a.x + b.x) / 2), y => ((a.y + b.y) / 2) ;
   C.new: c => center, r => (distSq(a, b).sqrt / 2)
} # returns smallest circle that intersects 2 points

sub secTrivial( @rs --> C ) {
   given @rs {
      when * == 0 { return C.new: c => (P.new: x => 0, y => 0), r => 0 }
      when * == 1 { return C.new: c => @rs[0], r => 0 }
      when * == 2 { return circleFrom2 |@rs }
      when * == 3 { #`{ no-op } }
      when *  > 3 { die "There shouldn't be more than 3 points." }
   }
   for 0, 1 X 1, 2 -> ( \i, \j ) {
      return $_ if .encloses(@rs) given circleFrom2 |@rs[i,j]
   }
   circleFrom3 |@rs
} # returns smallest enclosing circle for n ≤ 3

sub Welzl-helper( @ps is copy, @rs is copy , \n --> C ) {
   return secTrivial(@rs) if n == 0 or @rs == 3;
   my \p = @ps.shift;
   return $_ if .contains(p) given Welzl-helper @ps, @rs, n-1;
   Welzl-helper @ps, @rs.append(p), n-1
} # helper function for Welzl method

# applies the Welzl algorithm to find the SEC
sub welzl(@ps --> C) { Welzl-helper @ps.pick(*), [], @ps }

my @tests = (
   [ (0,0), (0,1), (1,0) ],
   [ (5,-2), (-3,-2), (-2,5), (1,6), (0,2) ]
).map: {
   @_.map: { P.new: x => $_[0], y => $_[1] }
}

say "Solution for smallest circle enclosing {$_.gist} :\n", welzl $_ for @tests;
