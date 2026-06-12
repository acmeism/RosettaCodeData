use Lingua::EN::Numbers;

sub abbr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '..' ~ .substr(*-20) ~ " (digits: {.chars})" }

my @wolstenholme = lazy ([\+] (1..∞).hyper.map: {FatRat.new: 1, .²}).map: *.numerator;

say 'Wolstenholme numbers:';
printf "%8s: %s\n", .&ordinal-digit(:c), abbr @wolstenholme[$_-1] for flat 1..20, 5e2, 1e3, 2.5e3, 5e3, 1e4;

say "\nPrime Wolstenholme numbers:";
printf "%8s: %s\n", .&ordinal-digit(:c), @wolstenholme.grep(&is-prime)[$_-1]».&abbr for 1..15;
