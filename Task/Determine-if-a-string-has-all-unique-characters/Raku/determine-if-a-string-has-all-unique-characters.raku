  -> $str {
    my $i = 0;
    print "\n{$str.raku} (length: {$str.chars}), has ";
    my %m;
    %m{$_}.push: ++$i for $str.comb;
    if any(%m.values) > 1 {
        say "duplicated characters:";
        say "'{.key}' ({.key.uninames}; hex ordinal: {(.key.ords).fmt: "0x%X"})" ~
        " in positions: {.value.join: ', '}" for %m.grep( *.value > 1 ).sort( *.value[0] );
    } else {
        say "no duplicated characters."
    }
} for
    '',
    '.',
    'abcABC',
    'XYZ ZYX',
    '1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ',
    '01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X',
    '🦋🙂👨‍👩‍👧‍👦🙄ΔΔ̂ 🦋Δ👍👨‍👩‍👧‍👦'
