package Nums;

use overload ('<=>' => \&compare);
sub new     { my $self = shift; bless [@_] }
sub flip    { my @a = @_; 1/$a }
sub double  { my @a = @_; 2*$a }
sub compare { my ($a, $b) = @_; abs($a) <=> abs($b) }

my $a = Nums->new(42);
print "$_\n" for %{ref ($a)."::" });
