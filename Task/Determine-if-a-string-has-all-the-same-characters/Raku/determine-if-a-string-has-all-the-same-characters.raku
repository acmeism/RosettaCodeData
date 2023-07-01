  -> $str {
    my $i = 0;
    print "\n{$str.raku} (length: {$str.chars}), has ";
    my %m;
    %m{$_}.push: ++$i for $str.comb;

    if %m > 1 {
        say "different characters:";
        say "'{.key}' ({.key.uninames}; hex ordinal: {(.key.ords).fmt: "0x%X"})" ~
        " in positions: {.value.join: ', '}" for %m.sort( *.value[0] );
    } else {
        say "the same character in all positions."
    }
} for
    '',
    '   ',
    '2',
    '333',
    '.55',
    'tttTTT',
    '4444 444k',
    '🇬🇧🇬🇧🇬🇧🇬🇧',
    "\c[LATIN CAPITAL LETTER A]\c[COMBINING DIAERESIS]\c[COMBINING MACRON]" ~
    "\c[LATIN CAPITAL LETTER A WITH DIAERESIS]\c[COMBINING MACRON]" ~
    "\c[LATIN CAPITAL LETTER A WITH DIAERESIS AND MACRON]",
    'AАΑꓮ𐌀𐊠Ꭺ'
