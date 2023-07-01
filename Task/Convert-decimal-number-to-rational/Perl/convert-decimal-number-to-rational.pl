sub gcd {
        my ($m, $n) = @_;
        ($m, $n) = ($n, $m % $n) while $n;
        return $m
}

sub rat_machine {
        my $n = shift;
        my $denom = 1;
        while ($n != int $n) {
                # assuming the machine format is base 2, and multiplying
                # by 2 doesn't change the mantissa
                $n *= 2;

                # multiply denom by 2, ignoring (very) possible overflow
                $denom <<= 1;
        }
        if ($n) {
                my $g = gcd($n, $denom);
                $n /= $g;
                $denom /= $g;
        }
        return $n, $denom;
}

# helper, make continued fraction back into normal fraction
sub get_denom {
        my ($num, $denom) = (1, pop @_);
        for (reverse @_) {
                ($num, $denom) = ($denom, $_ * $denom + $num);
        }
        wantarray ? ($num, $denom) : $denom
}

sub best_approx {
        my ($n, $limit) = @_;
        my ($denom, $neg);
        if ($n < 0) {
                $neg = 1;
                $n = -$n;
        }

        my $int = int($n);
        my ($num, $denom, @coef) = (1, $n - $int);

        # continued fraction, sort of
        while (1) {
                # make sure it terminates
                last if $limit * $denom < 1;
                my $i = int($num / $denom);

                # not the right way to get limit, but it works
                push @coef, $i;

                if (get_denom(@coef) > $limit) {
                        pop @coef;
                        last;
                }

                # we lose precision here, but c'est la vie
                ($num, $denom) = ($denom, $num - $i * $denom);
        }

        ($num, $denom) = get_denom @coef;
        $num += $denom * $int;

        return $neg ? -$num : $num, $denom;
}

sub rat_string {
        my $n = shift;
        my $denom = 1;
        my $neg;

        # trival xyz.0000 ... case
        $n =~ s/\.0+$//;
        return $n, 1 unless $n =~ /\./;

        if ($n =~ /^-/) {
                $neg = 1;
                $n =~ s/^-//;
        }

        # shift decimal point to the right till it's gone
        $denom *= 10    while $n =~ s/\.(\d)/$1\./;
        $n =~ s/\.$//;

        # removing leading zeros lest it looks like octal
        $n =~ s/^0*//;
        if ($n) {
                my $g = gcd($n, $denom);
                $n /= $g;
                $denom /= $g;
        }
        return $neg ? -$n : $n, $denom;
}

my $limit = 1e8;
my $x = 3/8;
print "3/8 = $x:\n";
printf "machine: %d/%d\n", rat_machine $x;
printf "string:  %d/%d\n", rat_string  $x;
printf "approx below $limit:  %d/%d\n", best_approx $x, $limit;

$x = 137/4291;
print "\n137/4291 = $x:\n";
printf "machine: %d/%d\n", rat_machine $x;
printf "string:  %d/%d\n", rat_string  $x;
printf "approx below $limit:  %d/%d\n", best_approx $x, $limit;

$x = sqrt(1/2);
print "\n1/sqrt(2) = $x\n";
printf "machine: %d/%d\n", rat_machine $x;
printf "string:  %d/%d\n", rat_string  $x;
printf "approx below 10:  %d/%d\n", best_approx $x, 10;
printf "approx below 100:  %d/%d\n", best_approx $x, 100;
printf "approx below 1000:  %d/%d\n", best_approx $x, 1000;
printf "approx below 10000:  %d/%d\n", best_approx $x, 10000;
printf "approx below 100000:  %d/%d\n", best_approx $x, 100000;
printf "approx below $limit:  %d/%d\n", best_approx $x, $limit;

$x = -4 * atan2(1,1);
print "\n-Pi = $x\n";
printf "machine: %d/%d\n", rat_machine $x;
printf "string:  %d/%d\n", rat_string  $x;

for (map { 10 ** $_ } 1 .. 10) {
        printf "approx below %g: %d / %d\n", $_, best_approx($x, $_)
}
