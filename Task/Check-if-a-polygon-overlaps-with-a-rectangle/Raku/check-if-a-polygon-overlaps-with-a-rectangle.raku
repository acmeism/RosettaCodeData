# 20230810 Raku programming solution

class Vector2 { has ( $.x, $.y );
   method dot ( \other ) { self.x * other.x + self.y * other.y }
};

class Rectangle { has ( $.x, $.y, $.w, $.h ) }

class Projection { has ( $.min, $.max ) };

sub getAxes(\poly) {
   return poly.append(poly[0]).rotor(2=>-1).map: -> (\vertex1,\vertex2) {
      my \vector1 = Vector2.new: x => vertex1[0], y => vertex1[1];
      my \vector2 = Vector2.new: x => vertex2[0], y => vertex2[1];
      my \edge    = Vector2.new: x => vector1.x - vector2.x,
                                 y => vector1.y - vector2.y;
      $_ = Vector2.new: x => -edge.y, y => edge.x
   }
}

sub projectOntoAxis(\poly, \axis) {
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

sub projectionsOverlap(\proj1, \proj2) {
   return ! ( proj1.max < proj2.min or proj2.max < proj1.min )
}

sub rectToPolygon( \r ) {
    return [(r.x, r.y), (r.x, r.y+r.h), (r.x+r.w, r.y+r.h), (r.x+r.w, r.y)]
}

sub polygonOverlapsRect(\poly1, \rect) {
   my \poly2 = rectToPolygon rect;
   my (\axes1,\axes2) := (poly1,poly2).map: { getAxes $_ };
   for (axes1, axes2) -> \axes {
     for axes -> \axis {
         my (\proj1,\proj2) := (poly1,poly2).map: { projectOntoAxis $_, axis }
         return False unless projectionsOverlap(proj1, proj2)
      }
   }
   return True
}

my \poly = [ <0 0>, <0 2>, <1 4>, <2 2>, <2 0> ];
my \rect1 = Rectangle.new: :4x, :0y, :2h, :2w;
my \rect2 = Rectangle.new: :1x, :0y, :8h, :2w;
say "poly  = ", poly;
say "rect1 = ", rectToPolygon(rect1);
say "rect2 = ", rectToPolygon(rect2);
say();
say "poly and rect1 overlap? ", polygonOverlapsRect(poly, rect1);
say "poly and rect2 overlap? ", polygonOverlapsRect(poly, rect2);
