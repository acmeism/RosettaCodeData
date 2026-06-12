use v5.36;
use experimental <builtin for_list>;
use List::AllUtils <firstidx all>;
use ntheory <is_prime divisors powmod>;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

my @poulet       = grep { !is_prime($_) && (1 == powmod 2, $_ - 1, $_) } 2 .. 1.1e7;
my @super_poulet = grep { all { 2 == powmod 2, $_, $_ } grep { $_ > 1 } divisors $_ } @poulet;

say "First 20 super-Poulet numbers:\n" . join ' ', @super_poulet[0..19];
for my($i,$j) (1, 1e6, 10, 1e7) {
    my $index = firstidx { $_ > $j } @super_poulet;
    say "\nIndex and value of first super-Poulet greater than $i million:";
    say "#@{[1+$index]} is " . comma $super_poulet[$index];
}
