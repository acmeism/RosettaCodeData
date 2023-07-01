use Prime::Factor;
use Lingua::EN::Numbers;

my %cache;

sub factor-char-sum ($n, $base = 10) { sum $n.&prime-factors.Bag.map: { .key.base($base).chars + (.value > 1 ?? .value.base($base).chars !! 0) } }

sub economical  ($n, $base = 10) { ($n >  1) && $n.base($base).chars >  (%cache{$base}[$n] //= factor-char-sum $n, $base) }
sub equidigital ($n, $base = 10) { ($n == 1) || $n.base($base).chars == (%cache{$base}[$n] //= factor-char-sum $n, $base) }
sub extravagant ($n, $base = 10) {              $n.base($base).chars <  (%cache{$base}[$n] //= factor-char-sum $n, $base) }


for 10, 11 -> $base {
    %cache{$base}[3e6] = Any; # preallocate to avoid concurrency issues
    say "\nIn Base $base:";
    for &extravagant, &equidigital, &economical -> &sub {
        say "\nFirst 50 {&sub.name} numbers:";
        say (^∞).grep( {.&sub($base)} )[^50].batch(10)».&comma».fmt("%6s").join: "\n";
        say "10,000th: " ~ (^∞).hyper(:2000batch).grep( {.&sub($base)} )[9999].&comma;
    }

    my $upto = 1e6.Int;
    my atomicint ($extravagant, $equidigital, $economical);
    say "\nOf the positive integers up to {$upto.&cardinal}:";
    (1..^$upto).race(:5000batch).map: { .&extravagant($base) ?? ++⚛$extravagant !! .&equidigital($base) ?? ++⚛$equidigital !! ++⚛$economical };
    say " Extravagant: {comma $extravagant}\n Equidigital: {comma $equidigital}\n  Economical: {comma $economical}";
    %cache{$base} = Empty;
}
