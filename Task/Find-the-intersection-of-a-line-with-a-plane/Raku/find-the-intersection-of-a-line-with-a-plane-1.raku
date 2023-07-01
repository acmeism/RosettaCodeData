class Line {
    has $.P0; # point
    has $.u⃗;  # ray
}
class Plane {
    has $.V0; # point
    has $.n⃗;  # normal
}

sub infix:<∙> ( @a, @b where +@a == +@b ) { [+] @a «*» @b } # dot product

sub line-plane-intersection ($𝑳, $𝑷) {
    my $cos = $𝑷.n⃗ ∙ $𝑳.u⃗; # cosine between normal & ray
    return 'Vectors are orthogonal; no intersection or line within plane'
      if $cos == 0;
    my $𝑊 = $𝑳.P0 «-» $𝑷.V0;      # difference between P0 and V0
    my $S𝐼 = -($𝑷.n⃗ ∙ $𝑊) / $cos;  # line segment where it intersects the plane
    $𝑊 «+» $S𝐼 «*» $𝑳.u⃗ «+» $𝑷.V0; # point where line intersects the plane
 }

say 'Intersection at point: ', line-plane-intersection(
     Line.new( :P0(0,0,10), :u⃗(0,-1,-1) ),
    Plane.new( :V0(0,0, 5), :n⃗(0, 0, 1) )
  );
