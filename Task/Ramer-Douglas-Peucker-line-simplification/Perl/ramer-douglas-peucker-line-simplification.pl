use strict;
use warnings;
use feature 'say';
use List::MoreUtils qw(firstidx minmax);

my $epsilon = 1;

sub norm {
    my(@list) = @_;
    my $sum;
    $sum += $_**2 for @list;
    sqrt($sum)
}

sub perpendicular_distance {
    our(@start,@end,@point);
    local(*start,*end,*point) = (shift, shift, shift);
    return 0 if $start[0]==$point[0] && $start[1]==$point[1]
             or   $end[0]==$point[0] &&   $end[1]==$point[1];
    my ( $dx,  $dy)  = (  $end[0]-$start[0],  $end[1]-$start[1]);
    my ($dpx, $dpy)  = ($point[0]-$start[0],$point[1]-$start[1]);
    my $t = norm($dx, $dy);
    $dx /= $t;
    $dy /= $t;
    norm($dpx - $dx*($dx*$dpx + $dy*$dpy), $dpy - $dy*($dx*$dpx + $dy*$dpy));
}

sub Ramer_Douglas_Peucker {
    my(@points) = @_;
    return @points if @points == 2;
    my @d;
    push @d, perpendicular_distance(@points[0, -1, $_]) for 0..@points-1;
    my(undef,$dmax) = minmax @d;
    my $index = firstidx { $_ == $dmax } @d;
    if ($dmax > $epsilon) {
        my @lo = Ramer_Douglas_Peucker( @points[0..$index]);
        my @hi = Ramer_Douglas_Peucker( @points[$index..$#points]);
        return  @lo[0..@lo-2], @hi;
    }
    @points[0, -1];
}

say '(' . join(' ', @$_) . ') '
    for Ramer_Douglas_Peucker( [0,0],[1,0.1],[2,-0.1],[3,5],[4,6],[5,7],[6,8.1],[7,9],[8,9],[9,9] )
