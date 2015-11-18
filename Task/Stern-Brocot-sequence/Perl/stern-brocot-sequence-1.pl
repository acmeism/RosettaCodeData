use strict;
use warnings;

sub stern_brocot {
    my @list = (1, 1);
    sub {
	push @list, $list[0] + $list[1], $list[1];
	shift @list;
    }
}

{
    my $generator = stern_brocot;
    print join ' ', map &$generator, 1 .. 15;
    print "\n";
}

for (1 .. 10, 100) {
    my $index = 1;
    my $generator = stern_brocot;
    $index++ until $generator->() == $_;
    print "first occurrence of $_ is at index $index\n";
}

{
    sub gcd {
	my ($u, $v) = @_;
	$v ? gcd($v, $u % $v) : abs($u);
    }
    my $generator = stern_brocot;
    my ($a, $b) = ($generator->(), $generator->());
    for (1 .. 1000) {
	die "unexpected GCD for $a and $b" unless gcd($a, $b) == 1;
	($a, $b) = ($b, $generator->());
    }
}
