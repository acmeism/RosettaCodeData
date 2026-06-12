sub MAIN ( Str $user_word = 'complition', Str $filename = 'words.txt' ) {
    my @s1 = $user_word.comb;
    my @listed = gather for $filename.IO.lines -> $line {
        my @s2 = $line.comb;

        my $correct = 100 * sum( @s1 Zeq @s2)
                          / max(+@s1,   +@s2);

        my $score = ( $correct >= 100            and @s1[0] eq @s2[0] ) ?? 100
                 !! ( $correct >=  80            and @s1[0] eq @s2[0] ) ?? $correct
                 !! ( $line.contains($user_word) and @s1 * 2 > @s2    ) ?? 80
                 !!                                                        0;
        take [$score, $line] if $score;
    }

    @listed = @listed[$_] with @listed.first: :k, { .[0] == 100 };

    say "{.[0].fmt('%.2f')}% {.[1]}" for @listed;
}
