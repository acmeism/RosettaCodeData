use strict;
use warnings;
use feature 'say';
use ntheory 'is_prime';
use List::AllUtils 'firstidx';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

my @cyclops = 0;
for my $exp (0..3) {
    my @oom = grep { ! /0/ } 10**$exp .. 10**($exp+1)-1;
    for my $l (@oom) {
        for my $r (@oom) {
            push @cyclops, $l . '0' . $r;
        }
    }
}

my @prime_cyclops = grep { is_prime $_           } @cyclops;
my @prime_blind   = grep { is_prime $_ =~ s/0//r } @prime_cyclops;
my @prime_palindr = grep { $_ eq reverse $_      } @prime_cyclops;

my $upto = 50;
my $over = 10_000_000;

for (
  ['', @cyclops],
  ['prime', @prime_cyclops],
  ['blind prime', @prime_blind],
  ['palindromic prime', @prime_palindr]) {
    my($text,@values) = @$_;
    my $i = firstidx { $_ > $over } @values;
    say "First $upto $text cyclops numbers:\n" .
        (sprintf "@{['%8d' x $upto]}", @values[0..$upto-1]) =~ s/(.{80})/$1\n/gr;
    printf "First $text number > %s: %s at (zero based) index: %s\n\n", map { comma($_) } $over, $values[$i], $i;
}
