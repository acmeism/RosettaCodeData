use strict;
use warnings;
use feature 'say';
use Math::AnyNum qw(:overload);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub endsWithOne {
    my($n) = @_;
    my $digit;
    my $sum = 0;
    my $nn  = $n;
    while () {
        while ($nn > 0) {
            $digit = $nn % 10;
            $sum  += $digit**2;
            $nn    = int $nn / 10;
        }
        return 1 if $sum ==  1;
        return 0 if $sum == 89;
        $nn = $sum;
        $sum = 0;
    }
}

my @ks = <7 8 11 14 17>;

for my $k (@ks) {
    my @sums = <1 0>;
    my $s;
    for my $n (1 .. $k) {
        for my $i (reverse 1 .. $n*81) {
            for my $j (1 .. 9) {
                no warnings 'uninitialized';
                last if ($s = $j**2) > $i;
                $sums[$i] += $sums[$i-$s];
            }
        }
   }
   my $count1 = 0;
   for my $i (1 .. $k*81) { $count1 += $sums[$i] if endsWithOne($i) }
   my $limit = 10**$k - 1;
   say "For k = $k in the range 1 to " . comma $limit;
   say comma($count1) . ' numbers produce 1 and ' . comma($limit-$count1) . " numbers produce 89\n";
}
