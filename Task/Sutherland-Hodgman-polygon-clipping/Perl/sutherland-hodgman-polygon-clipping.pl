use strict;
use warnings;

sub intersection {
    my($L11, $L12, $L21, $L22) = @_;
    my ($d1x, $d1y) = ($$L11[0] - $$L12[0], $$L11[1] - $$L12[1]);
    my ($d2x, $d2y) = ($$L21[0] - $$L22[0], $$L21[1] - $$L22[1]);
    my $n1 = $$L11[0] * $$L12[1] - $$L11[1] * $$L12[0];
    my $n2 = $$L21[0] * $$L22[1] - $$L21[1] * $$L22[0];
    my $n3 = 1 / ($d1x * $d2y - $d2x * $d1y);
    [($n1 * $d2x - $n2 * $d1x) * $n3, ($n1 * $d2y - $n2 * $d1y) * $n3]
}

sub is_inside {
    my($p1, $p2, $p3) = @_;
    ($$p2[0] - $$p1[0]) * ($$p3[1] - $$p1[1]) > ($$p2[1] - $$p1[1]) * ($$p3[0] - $$p1[0])
}

sub sutherland_hodgman {
    my($polygon, $clip) = @_;
    my @output = @$polygon;
    my $clip_point1 = $$clip[-1];
    for my $clip_point2 (@$clip) {
        my @input = @output;
        @output = ();
        my $start = $input[-1];
        for my $end (@input) {
            if (is_inside($clip_point1, $clip_point2, $end)) {
                push @output, intersection($clip_point1, $clip_point2, $start, $end)
                  unless is_inside($clip_point1, $clip_point2, $start);
                push @output, $end;
            } elsif (is_inside($clip_point1, $clip_point2, $start)) {
                push @output, intersection($clip_point1, $clip_point2, $start, $end);
            }
            $start = $end;
        }
        $clip_point1 = $clip_point2;
    }
    @output
}

my @polygon = ([50,  150], [200, 50],  [350, 150], [350, 300], [250, 300],
              [200, 250], [150, 350], [100, 250], [100, 200]);

my @clip    = ([100, 100], [300, 100], [300, 300], [100, 300]);

my @clipped = sutherland_hodgman(\@polygon, \@clip);

print "Clipped polygon:\n";
print '(' . join(' ', @$_) . ') ' for @clipped;
