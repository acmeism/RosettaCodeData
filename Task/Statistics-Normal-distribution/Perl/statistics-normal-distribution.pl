use constant pi => 3.14159265;
use List::Util qw(sum reduce min max);

sub normdist {
    my($m, $sigma) = @_;
    my $r = sqrt -2 * log rand;
    my $theta = 2 * pi * rand;
    $r * cos($theta) * $sigma + $m;
}

$size = 100000; $mean = 50; $stddev = 4;

push @dataset, normdist($mean,$stddev) for 1..$size;

my $m = sum(@dataset) / $size;
print "m = $m\n";

my $sigma = sqrt( (reduce { $a + $b **2 } 0,@dataset) / $size - $m**2 );
print "sigma = $sigma\n";

    $hash{int $_}++ for @dataset;
    my $scale = 180 * $stddev / $size;
    my @subbar = < ⎸ ▏ ▎ ▍ ▌ ▋ ▊ ▉ █ >;
    for $i (min(@dataset)..max(@dataset)) {
        my $x = ($hash{$i} // 0) * $scale;
        my $full = int $x;
        my $part = 8 * ($x - $full);
        my $t1 = '█' x $full;
        my $t2 = $subbar[$part];
        print "$i\t$t1$t2\n";
    }
