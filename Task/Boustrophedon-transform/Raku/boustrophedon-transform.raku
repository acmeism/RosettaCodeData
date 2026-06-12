sub boustrophedon-transform (@seq) { map *.tail, (@seq[0], {[[\+] flat @seq[++$ ], .reverse]}…*) }

sub abbr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '…' ~ .substr(*-20) ~ " ({.chars} digits)" }

for '1 followed by 0\'s A000111', (flat 1, 0 xx *),
    'All-1\'s           A000667', (flat 1 xx *),
    '(-1)^n             A062162', (flat 1, [\×] -1 xx *),
    'Primes             A000747', (^∞ .grep: &is-prime),
    'Fibonaccis         A000744', (1,1,*+*…*),
    'Factorials         A230960', (1,|[\×] 1..∞)
  -> $name, $seq
{ say "\n$name:\n" ~ (my $b-seq = boustrophedon-transform $seq)[^15] ~ "\n1000th term: " ~ abbr $b-seq[999] }
