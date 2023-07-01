use Math::Primesieve;
my $sieve = Math::Primesieve.new;

my $max = 1_000_000;
my @primes = $sieve.primes($max);
my $filter = @primes.Set;
my $primes = @primes.categorize: &successive;

sub successive ($i) {
    gather {
        take '2' if $filter{$i + 2};
        take '1' if $filter{$i + 1};
        take '2_2' if all($filter{$i «+« (2,4)});
        take '2_4' if all($filter{$i «+« (2,6)});
        take '4_2' if all($filter{$i «+« (4,6)});
        take '6_4_2' if all($filter{$i «+« (6,10,12)}) and
            none($filter{$i «+« (2,4,8)});
    }
}

sub comma { $^i.flip.comb(3).join(',').flip }

for (2,), (1,), (2,2), (2,4), (4,2), (6,4,2) -> $succ {
    say "## Sets of {1+$succ} successive primes <= { comma $max } with " ~
        "successive differences of { $succ.join: ', ' }";
    my $i = $succ.join: '_';
    for 'First', 0, ' Last', * - 1 -> $where, $ind {
        say "$where group: ", join ', ', [\+] flat $primes{$i}[$ind], |$succ
    }
    say '      Count: ', +$primes{$i}, "\n";
}
