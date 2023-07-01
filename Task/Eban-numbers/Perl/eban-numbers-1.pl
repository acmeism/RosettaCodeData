use strict;
use warnings;
use feature 'say';
use Lingua::EN::Numbers qw(num2en);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub e_ban {
    my($power) = @_;
    my @n;
    for (1..10**$power) {
        next unless 0 == $_%2;
        next if $_ =~ /[789]/ or /[12].$/ or /[135]..$/ or /[135]...$/ or /[135].....$/;
        push @n, $_ unless num2en($_) =~ /e/;
    }
    @n;
}

my @OK = e_ban(my $max = 7);

my @a = grep { $_ <= 1000 } @OK;
say "Number of eban numbers up to and including 1000: @{[1+$#a]}";
say join(', ',@a);
say '';

my @b = grep { $_ >= 1000 && $_ <= 4000 } @OK;
say "Number of eban numbers between 1000 and 4000 (inclusive): @{[1+$#b]}";
say join(', ',@b);
say '';

for my $exp (4..$max) {
    my $n = + grep { $_ <= 10**$exp } @OK;
    printf "Number of eban numbers and %10s: %d\n", comma(10**$exp), $n;
}
