use Lingua::EN::Numbers;

my @primes = (^∞).grep: &is-prime;

my @Smarandache-Wellin = [\~] @primes;

sink @Smarandache-Wellin[1500]; # pre-reify for concurrency

sub derived ($n) { my %digits = $n.comb.Bag; (0..9).map({ %digits{$_} // 0 }).join }

sub abbr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '…' ~ .substr(*-20) ~ " ({.chars} digits)" }

say "Smarandache-Wellin primes:";
say ordinal-digit(++$,:u).fmt("%4s") ~ $_ for (^∞).hyper(:4batch).map({
    next unless (my $sw = @Smarandache-Wellin[$_]).is-prime;
    sprintf ": Index: %4d, Last prime: %5d, %s", $_, @primes[$_], $sw.&abbr
})[^8];

say "\nSmarandache-Wellin derived primes:";
say ordinal-digit(++$,:u).fmt("%4s") ~ $_ for (^∞).hyper(:8batch).map({
    next unless (my $sw = @Smarandache-Wellin[$_].&derived).is-prime;
    sprintf ": Index: %4d, %s", $_, $sw
})[^20];
