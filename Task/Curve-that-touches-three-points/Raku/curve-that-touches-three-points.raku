use Image::PNG::Portable;

# the points of interest
my @points = (10,10), (100,200), (200,10);

# Solve for a quadratic line that passes through those points
my (\a, \b, \c) = (rref ([.[0]², .[0], 1, .[1]] for @points) )[*;*-1];

# Evaluate quadratic equation
sub f (\x) { a×x² + b×x + c }

my ($w, $h) = 500, 500;  # image size
my $scale   = 2;         # scaling factor

my $png = Image::PNG::Portable.new: :width($w), :height($h);

my ($lastx, $lasty) = 8, f(8).round;
(9 .. 202).map: -> $x {
    my $f = f($x).round;
    line($lastx, $lasty, $x, $f, $png, [0,255,127]);
    ($lastx, $lasty) = $x, $f;
}

# Highlight the defining points
dot( | $_, $(255,0,0), $png, 2) for @points;

$png.write: 'Curve-3-points-perl6.png';

# Assorted helper routines
sub rref (@m) {
    return unless @m;
    my ($lead, $rows, $cols) = 0, @m, @m[0];
    for ^$rows -> $r {
        $lead < $cols or return @m;
        my $i = $r;
        until @m[$i;$lead] {
            ++$i == $rows or next;
            $i = $r;
            ++$lead == $cols and return @m;
        }
        @m[$i, $r] = @m[$r, $i] if $r != $i;
        @m[$r] »/=» $ = @m[$r;$lead];
        for ^$rows -> $n {
            next if $n == $r;
            @m[$n] »-=» @m[$r] »×» (@m[$n;$lead] // 0);
        }
        ++$lead;
    }
    @m
}

sub line($x0 is copy, $y0 is copy, $x1 is copy, $y1 is copy, $png, @rgb) {
    my $steep = abs($y1 - $y0) > abs($x1 - $x0);
    ($x0,$y0,$x1,$y1) »×=» $scale;
    if $steep {
        ($x0, $y0) = ($y0, $x0);
        ($x1, $y1) = ($y1, $x1);
    }
    if $x0 > $x1 {
        ($x0, $x1) = ($x1, $x0);
        ($y0, $y1) = ($y1, $y0);
    }
    my $Δx = $x1 - $x0;
    my $Δy = abs($y1 - $y0);
    my $error = 0;
    my $Δerror = $Δy / $Δx;
    my $y-step = $y0 < $y1 ?? 1 !! -1;
    my $y = $y0;
    next if $y < 0;
    for $x0 .. $x1 -> $x {
        next if $x < 0;
        if $steep {
            $png.set($y, $x, |@rgb);
        } else {
            $png.set($x, $y, |@rgb);
        }
        $error += $Δerror;
        if $error ≥ 0.5 {
            $y += $y-step;
            $error -= 1.0;
        }
    }
}

sub dot ($X is copy, $Y is copy, @rgb, $png, $radius = 3) {
    ($X, $Y) »×=» $scale;
    for ($X X+ -$radius .. $radius) X ($Y X+ -$radius .. $radius) -> ($x, $y) {
        $png.set($x, $y, |@rgb) if ( $X - $x + ($Y - $y) × i ).abs <= $radius;
    }
}
