use strict;

my @a = (-1 , -2 , 3 , 5 , 6 , -2 , -1 , 4 , -4 , 2 , -1);

my @maxsubarray;
my $maxsum = 0;

foreach my $begin (0..$#a) {
        foreach my $end ($begin..$#a) {
                my $sum = 0;
                $sum += $_ foreach @a[$begin..$end];
                if($sum > $maxsum) {
                        $maxsum = $sum;
                        @maxsubarray = @a[$begin..$end];
                }
        }
}

print "@maxsubarray\n";
