use strict;
use warnings;

# For mutually recursive functions,
# predeclaring is probably a good idea.
sub M; sub F;

sub F { my $n = shift; $n ? $n - M F $n-1 : 1 }
sub M { my $n = shift; $n ? $n - F M $n-1 : 0 }

for my $f (\&F, \&M) {
    print join(' ', map $f->($_), 0 .. 19), "\n";
}
