use Lingua::EN::Numbers;
use ntheory:from<Perl5> <:all>;

# Implemented as a lazy, extendable list
my $spds = grep { .&is_prime }, flat [2,3,5,7], [23,27,33,37,53,57,73,77], -> $p
  { state $o++; my $oom = 10**(1+$o); [ flat (2,3,5,7).map: -> $l { (|$p).map: $l×$oom + * } ] } … *;

say 'Smarandache prime-digitals:';
printf "%22s: %s\n", ordinal(1+$_).tclc, comma $spds[$_] for flat ^25, 99, 999, 9999, 99999;
