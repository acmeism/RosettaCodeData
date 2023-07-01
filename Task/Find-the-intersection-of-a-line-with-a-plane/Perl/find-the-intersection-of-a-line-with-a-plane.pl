package  Line; sub new { my ($c, $a) = @_; my $self = { P0 => $a->{P0}, u => $a->{u} } } # point / ray
package Plane; sub new { my ($c, $a) = @_; my $self = { V0 => $a->{V0}, n => $a->{n} } } # point / normal

package main;

sub dot { my $p; $p    += $_[0][$_] * $_[1][$_] for 0..@{$_[0]}-1; $p } # dot product
sub vd  { my @v; $v[$_] = $_[0][$_] - $_[1][$_] for 0..@{$_[0]}-1; @v } # vector difference
sub va  { my @v; $v[$_] = $_[0][$_] + $_[1][$_] for 0..@{$_[0]}-1; @v } # vector addition
sub vp  { my @v; $v[$_] = $_[0][$_] * $_[1][$_] for 0..@{$_[0]}-1; @v } # vector product

sub line_plane_intersection {
    my($L, $P) = @_;

    my $cos = dot($L->{u}, $P->{n});     # cosine between normal & ray
    return 'Vectors are orthogonol; no intersection or line within plane' if $cos == 0;

    my @W = vd($L->{P0},$P->{V0});       # difference between P0 and V0
    my $SI = -dot($P->{n}, \@W) / $cos;  # line segment where it intersets the plane

    my @a = vp($L->{u},[($SI)x3]);
    my @b = va($P->{V0},\@a);
    va(\@W,\@b);
}

my $L =  Line->new({ P0=>[0,0,10], u=>[0,-1,-1]});
my $P = Plane->new({ V0=>[0,0,5 ], n=>[0, 0, 1]});
print 'Intersection at point: ', join(' ', line_plane_intersection($L, $P)) . "\n";
