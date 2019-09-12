use strict;
use warnings;
use List::Util 'min';

# If you want the large output, uncomment either the one line
# marked (1) or the two lines marked (2)
#use Math::GMP qw/:constant/;        # (1) uncomment this to use Math::GMP
#use Math::GMPz;                     # (2) uncomment this plus later line for Math::GMPz

sub ham_gen {
    my @s = ([1], [1], [1]);
    my @m = (2, 3, 5);
    #@m = map { Math::GMPz->new($_) } @m;     # (2) uncomment for Math::GMPz

    return sub {
	my $n = min($s[0][0], $s[1][0], $s[2][0]);
	for (0 .. 2) {
	     shift @{$s[$_]} if $s[$_][0] == $n;
	     push @{$s[$_]}, $n * $m[$_]
	}
	return $n
    }
}

my $h = ham_gen;
my $i = 0;
++$i, print $h->(), " " until $i > 20;
print "...\n";

++$i, $h->() until $i == 1690;
print ++$i, "-th: ", $h->(), "\n";

# You will need to pick one of the bigint choices
#++$i, $h->() until $i == 999999;
#print ++$i, "-th: ", $h->(), "\n";
