my @nums = prompt("Please type 11 space-separated numbers: ").words
    until @nums == 11;
for @nums.reverse -> $n {
    my $r = $n.abs.sqrt + 5 * $n ** 3;
    say "$n\t{ $r > 400 ?? 'Urk!' !! $r }";
}
