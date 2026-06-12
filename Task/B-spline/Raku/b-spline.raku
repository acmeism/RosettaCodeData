# 20211112 Raku programming solution

use Cairo;

# class point_t { has Num ($.x,$.y) is rw } # get by with two element lists
class line_t  { has ($.A,$.B) is rw }

my (\WIDTH,  \HEIGHT,  \W_LINE,  \CURVE_F,  \DETACHED,          \OUTPUT  ) =
       400,      400,        2,      0.25,          0,  './b-spline.png' ;

my \cnt = #`(Number of points) ( my \pt = [
   [171, 171], [185, 111], [202, 109], [202, 189], [328, 160], [208, 254],
   [241, 330], [164, 252], [ 69, 278], [139, 208], [ 72, 148], [168, 172], ]
).elems;

sub angle(\g) { atan2(g.B.[1] - g.A.[1], g.B.[0] - g.A.[0]) }

sub control_points(\g, \l, @p1, @p2){

#`[ This function calculates the control points. It takes two lines g and l as
 * arguments but it takes three lines into account for calculation. This is
 * line g (P0/P1), line h (P1/P2), and line l (P2/P3). The control points being
 * calculated are actually those for the middle line h, this is from P1 to P2.
 * Line g is the predecessor and line l the successor of line h.
 * @param g Pointer to first line (P0 to P1)
 * @param l Pointer to third line (P2 to P3)
 * @param p1 Pointer to memory of first control point.
 * @param p2 Pointer to memory of second control point. ]

   my \h = $ = line_t.new;

   my \lgt = sqrt([+]([ g.B.[0]-l.A.[0], g.B.[1]-l.A.[1] ]>>²));#length of P1 to P2

   h.B = l.A.clone;  # end point of 1st tangent
   # start point of tangent at same distance as end point along 'g'
   h.A = g.B.[0] - lgt * cos(angle g) , g.B.[1] - lgt * sin(angle g);

   my $a = angle h ; # angle of tangent
   # 1st control point on tangent at distance 'lgt * CURVE_F'
   @p1 = g.B.[0] + lgt * cos($a) * CURVE_F,  g.B.[1] + lgt * sin($a) * CURVE_F;

   h.A = g.B.clone; # start point of 2nd tangent
   # end point of tangent at same distance as start point along 'l'
   h.B = l.A.[0] + lgt * cos(angle l) , l.A.[1] + lgt * sin(angle l);

   $a = angle h; # angle of tangent
   # 2nd control point on tangent at distance 'lgt * CURVE_F'
   @p2 = l.A.[0] - lgt * cos($a) * CURVE_F,  l.A.[1] - lgt * sin($a) * CURVE_F;
}


given Cairo::Image.create(Cairo::FORMAT_ARGB32, WIDTH, HEIGHT) {
   given Cairo::Context.new($_) {
      my line_t ($g,$l);
      my (@p1,@p2);

      .line_width = W_LINE;
      .move_to(pt[DETACHED - 1 + cnt].[0], pt[DETACHED - 1 + cnt].[1]);

      for DETACHED..^cnt -> \j {
         $g = line_t.new: A=>pt[(j + cnt - 2) % cnt], B=>pt[(j + cnt - 1) % cnt];
         $l = line_t.new: A=>pt[(j + cnt + 0) % cnt], B=>pt[(j + cnt + 1) % cnt];

         # Calculate controls points for points pt[j-1] and pt[j].
         control_points($g, $l, @p1, @p2);

         .curve_to(@p1[0], @p1[1], @p2[0], @p2[1], pt[j].[0], pt[j].[1]);
      }
      .stroke;
   };
   .write_png(OUTPUT) and die # C return
}
