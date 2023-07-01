use strict;
use warnings;
use feature 'say';
use List::Util qw(uniqstr any);

my(%words,@teacups,%seen);

open my $fh, '<', 'ref/wordlist.10000';
while (<$fh>) {
    chomp(my $w = uc $_);
    next if length $w < 3;
    push @{$words{join '', sort split //, $w}}, $w;}

for my $these (values %words) {
    next if @$these < 3;
    MAYBE: for (@$these) {
        my $maybe = $_;
        next if $seen{$_};
        my @print;
        for my $i (0 .. length $maybe) {
            if (any { $maybe eq $_ } @$these) {
                push @print, $maybe;
                $maybe = substr($maybe,1) . substr($maybe,0,1)
            } else {
                @print = () and next MAYBE
            }
        }
        if (@print) {
            push @teacups, [@print];
            $seen{$_}++ for @print;
        }
    }
}

say join ', ', uniqstr @$_ for sort @teacups;
