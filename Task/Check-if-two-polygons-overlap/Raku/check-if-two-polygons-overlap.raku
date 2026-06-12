# 20230810 Raku programming solution

class Vector2 { has ( $.x, $.y );
   method dot ( \other ) { self.x * other.x + self.y * other.y }
};

class Projection { has ( $.min, $.max ) };

sub getAxes ( \poly ) {
   return poly.append(poly[0]).rotor(2=>-1).map: -> (\vertex1,\vertex2) {
      my \vector1 = Vector2.new: x => vertex1[0], y => vertex1[1];
      my \vector2 = Vector2.new: x => vertex2[0], y => vertex2[1];
      my \edge    = Vector2.new: x => vector1.x - vector2.x,
                                 y => vector1.y - vector2.y;
      $_ = Vector2.new: x => -edge.y, y => edge.x
   }
}

sub projectOntoAxis ( \poly, \axis ) {
   my \vertex0 = poly[0];
   my \vector0 = Vector2.new: x => vertex0[0], y => vertex0[1];
   my $max     = my $min = axis.dot: vector0;
   for poly -> \vertex {
      my \vector = Vector2.new: x => vertex[0], y => vertex[1];
      given axis.dot: vector { when $_ < $min { $min = $_ }
                               when $_ > $max { $max = $_ } }
   }
   return Projection.new: min => $min, max => $max
}

sub projectionsOverlap ( \proj1, \proj2 ) {
   return ! ( proj1.max < proj2.min or proj2.max < proj1.min )
}

sub polygonsOverlap( \poly1, \poly2 ) {
   my (\axes1,\axes2) := (poly1,poly2).map: { getAxes $_ };
   for (axes1, axes2) -> \axes {
     for axes -> \axis {
         my (\proj1,\proj2) := (poly1,poly2).map: { projectOntoAxis $_, axis }
         return False unless projectionsOverlap(proj1, proj2)
      }
   }
   return True
}

my \poly1 = [ <0 0>, <0 2>, <1 4>, <2 2>, <2 0> ];
my \poly2 = [ <4 0>, <4 2>, <5 4>, <6 2>, <6 0> ];
my \poly3 = [ <1 0>, <1 2>, <5 4>, <9 2>, <9 0> ];

say "poly1 = ", poly1;
say "poly2 = ", poly2;
say "poly3 = ", poly3;
say();
say "poly1 and poly2 overlap? ", polygonsOverlap(poly1, poly2);
say "poly1 and poly3 overlap? ", polygonsOverlap(poly1, poly3);
say "poly2 and poly3 overlap? ", polygonsOverlap(poly2, poly3);
