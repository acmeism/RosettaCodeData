use Math::Primesieve;
use Lingua::EN::Numbers;

my ($exp1, $exp2, $limit1, $limit2)  = 3, 8, 100, 250;
my ($n, $s0, $s1, $p, @S1, %S) =  1, 1, Any, Any, 1;
my $iterator = Math::Primesieve::iterator.new;
my @Nth = ($exp1..$exp2)».exp(10);
my $S2 = BagHash.new;

repeat {
    $n++;
    $s1 = $s0 %% 2 ?? $s0 div 2 !! $s0 + ($p = $iterator.next);
    @S1.push: $s1 if  $n ≤ $limit1;
    $S2.add:  $s1 if $s1 ≤ $limit2;
    %S{$n}{'value', 'prime'} = $s1, $p if $n ∈ @Nth;
    $s0 = $s1;
} until $n == @Nth[*-1];

say "The first $limit1 members of the Sisyphus sequence are:";
say @S1.batch(10)».fmt('%4d').join("\n") ~ "\n";
printf "%12sth member is: %13s with prime: %11s\n", ($_, %S{$_}{'value'}, %S{$_}{'prime'})».&comma for @Nth;
say "\nNumbers under $limit2 that do not occur in the first {comma @Nth[*-1]} terms:";
say (1..$limit2).grep: * ∉ $S2.keys;
say "\nNumbers under $limit2 that occur the most ({$S2.values.max} times) in the first {comma @Nth[*-1]} terms:";
say $S2.keys.grep({ $S2{$_} == $S2.values.max}).sort;
