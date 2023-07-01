use Lingua::EN::Numbers;
use ntheory:from<Perl5> <pn_primorial>;

say "First ten primorials: ", ^10 .map( { pn_primorial($_) } ).join: ', ';

 for 1..8 {
    my $now = now;
    printf "primorial(10^%d) has %-11s digits - %s\n", $_,
        comma(pn_primorial(10**$_).Str.chars),
        "Elapsed seconds: {(now - $now).round: .001}";
}
