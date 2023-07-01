for (5, [2,1]), (5, []), (10, [8]), (5, [2,3]), (15, [2,3,2,3]) -> ($cells, @blocks) {
    say $cells, ' cells with blocks: ', @blocks ?? join ', ', @blocks !! '∅';
    my $letter = 'A';
    my $row = join '.', map { $letter++ x $_ }, @blocks;
    say "no solution\n" and next if $cells < $row.chars;
    say $row ~= '.' x $cells - $row.chars;
    say $row while $row ~~ s/^^ (\.*) <|w> (.*?) <|w> (\w+) \.<!|w> /$1$0.$2/;
    say '';
}
