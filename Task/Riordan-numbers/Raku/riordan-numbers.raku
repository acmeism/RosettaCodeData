use Lingua::EN::Numbers;

my @riordan = 1, 0, { state $n = 1; (++$n - 1) / ($n + 1) × (3 × $^a + 2 × $^b) } … *;

my $upto = 32;
say "First {$upto.&cardinal} Riordan numbers:\n" ~ @riordan[^$upto]».&comma».fmt("%17s").batch(4).join("\n") ~ "\n";

sub abr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '..' ~ .substr(*-20) ~ " ({.chars} digits)" }

say "The {.Int.&ordinal}: " ~ abr @riordan[$_ - 1] for 1e3, 1e4
