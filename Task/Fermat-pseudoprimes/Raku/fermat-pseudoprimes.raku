use List::Divvy;
for 1..20 -> $base {
    my @pseudo = lazy (2..*).hyper.grep: { !.is-prime && (1 == expmod $base, $_ - 1, $_) }
    my $threshold = 100_000;
    say $base.fmt("Base %2d - Up to $threshold: ") ~ (+@pseudo.&upto: $threshold).fmt('%5d')
        ~ "  First 20: " ~ @pseudo[^20].gist
}
