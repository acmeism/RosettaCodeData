use ntheory qw(todigits);
use Math::Complex;

$sides = 5;
$order = 5;
$dim   = 250;
$scale = ( 3 - 5**.5 ) / 2;
push @orders, ((1 - $scale) * $dim) * $scale ** $_ for 0..$order-1;

open $fh, '>', 'sierpinski_pentagon.svg';
print $fh qq|<svg height="@{[$dim*2]}" width="@{[$dim*2]}" style="fill:blue" version="1.1" xmlns="http://www.w3.org/2000/svg">\n|;

$tau = 2 * 4*atan2(1, 1);
push @vertices, cis( $_ * $tau / $sides ) for 0..$sides-1;

for $i (0 .. -1+$sides**$order)  {
    @base5 = todigits($i,5);
    @i = ( ((0)x(-1+$sides-$#base5) ), @base5);
    @v = @vertices[@i];
    $vector = 0;
    $vector += $v[$_] * $orders[$_] for 0..$#orders;

    my @points;
    for (@vertices) {
        $v = $vector + $orders[-1] * (1 - $scale) * $_;
        push @points, sprintf '%.3f %.3f', $v->Re, $v->Im;
    }
    print $fh pgon(@points);
}

sub cis  { Math::Complex->make(cos($_[0]), sin($_[0])) }
sub pgon { my(@q)=@_; qq|<polygon points="@q" transform="translate($dim,$dim) rotate(-18)"/>\n| }

print $fh '</svg>';
close $fh;
