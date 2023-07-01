use strict;
use warnings;
use List::Util 1.33 qw(sum pairmap);

sub partition {
    my @mask = @_;
    my $last = sum @mask or return [map {[]} 0..$#mask];

    return pairmap {
        $b ? do {
            local $mask[$a] = $b - 1;
            map { push @{$_->[$a]}, $last; $_ }
                partition(@mask);
        } : ()
    } %mask[0..$#mask];
}

# Input & Output handling:

print "(" . join(', ', map { "{".join(', ', @$_)."}" } @$_) . ")\n"
    for partition( @ARGV ? @ARGV : (2, 0, 2) );
