use strict;
package LCG;

use overload '0+'  => \&get;

use integer;
sub gen_bsd { (1103515245 * shift() + 12345) % (1 << 31) }

sub gen_ms  {
	my $s = (214013 * shift() + 2531011) % (1 << 31);
	$s, $s / (1 << 16)
}

sub set { $_[0]->{seed} = $_[1] } # srand
sub get {
	my $o = shift;
	($o->{seed}, my $r) = $o->{meth}->($o->{seed});
	$r //= $o->{seed}
}

sub new {
	my $cls = shift;
	my %opts = @_;
	bless {
		seed => $opts{seed},
		meth => $opts{meth} eq 'MS' ? \&gen_ms : \&gen_bsd,
	}, ref $cls || $cls;
}

package main;

my $rand = LCG->new;

print "BSD:\n";
print "$rand\n" for 1 .. 10;

$rand = LCG->new(meth => 'MS');

print "\nMS:\n";
print "$rand\n" for 1 .. 10;
