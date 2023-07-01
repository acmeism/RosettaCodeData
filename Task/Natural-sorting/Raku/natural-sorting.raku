# Sort groups of digits in number order. Sort by order of magnitude then lexically.
sub naturally ($a) { $a.lc.subst(/(\d+)/, ->$/ {0~$0.chars.chr~$0},:g) ~"\x0"~$a }

# Collapse multiple ws characters to a single.
sub collapse ($a) { $a.subst( / ( \s ) $0+ /, -> $/ { $0 }, :g ) }

# Convert all ws characters to a space.
sub normalize ($a) { $a.subst( / ( \s ) /, ' ', :g ) }

# Ignore common leading articles for title sorts
sub title ($a) { $a.subst( / :i ^ ( a | an | the ) >> \s* /, '' ) }

# Decompose ISO-Latin1 glyphs to their base character.
sub latin1_decompose ($a) {
    $a.trans: <
       Æ AE æ ae Þ TH þ th Ð TH ð th ß ss À A Á A Â A Ã A Ä A Å A à a á a
        â a ã a ä a å a Ç C ç c È E É E Ê E Ë E è e é e ê e ë e Ì I Í I Î
        I Ï I ì i í i î i ï i Ò O Ó O Ô O Õ O Ö O Ø O ò o ó o ô o õ o ö o
        ø o Ñ N ñ n Ù U Ú U Û U Ü U ù u ú u û u ü u Ý Y ÿ y ý y
    >.hash;
}

# Used as:

my @tests = (
    [
        "Task 1a\nSort while ignoring leading spaces.",
        [
          'ignore leading spaces: 1', '   ignore leading spaces: 4',
          '  ignore leading spaces: 3', ' ignore leading spaces: 2'
        ],
        {.trim} # builtin method.
    ],
    [
        "Task 1b\nSort while ignoring multiple adjacent spaces.",
        [
          'ignore m.a.s   spaces: 3', 'ignore m.a.s spaces: 1',
          'ignore m.a.s    spaces: 4', 'ignore m.a.s  spaces: 2'
        ],
        {.&collapse}
    ],
    [
        "Task 2\nSort with all white space normalized to regular spaces.",
        [
          "Normalized\tspaces: 4", "Normalized\xa0spaces: 1",
          "Normalized\x20spaces: 2", "Normalized\nspaces: 3"
        ],
        {.&normalize}
    ],
    [
        "Task 3\nSort case independently.",
        [
          'caSE INDEPENDENT: 3', 'casE INDEPENDENT: 2',
          'cASE INDEPENDENT: 4', 'case INDEPENDENT: 1'
        ],
        {.lc} # builtin method
    ],
    [
        "Task 4\nSort groups of digits in natural number order.",
        [
          <Foo100bar99baz0.txt foo100bar10baz0.txt foo1000bar99baz10.txt
           foo1000bar99baz9.txt 201st 32nd 3rd 144th 17th 2 95>
        ],
        {.&naturally}
    ],
    [
        "Task 5 ( mixed with 1, 2, 3 & 4 )\n"
        ~ "Sort titles, normalize white space, collapse multiple spaces to\n"
        ~ "single, trim leading white space, ignore common leading articles\n"
        ~ 'and sort digit groups in natural order.',
        [
          'The Wind	in the Willows  8', '  The 39 Steps               3',
          'The    7th Seal              1', 'Wanda                        6',
          'A Fish Called Wanda          5', ' The Wind and the Lion       7',
          'Any Which Way But Loose      4', '12 Monkeys                   2'
        ],
        {.&normalize.&collapse.trim.&title.&naturally}
    ],
    [
        "Task 6, 7, 8\nMap letters in Latin1 that have accents or decompose to two\n"
        ~ 'characters to their base characters for sorting.',
        [
          <apple Ball bald car Card above Æon æon aether
            niño nina e-mail Évian evoke außen autumn>
        ],
        {.&latin1_decompose.&naturally}
    ]
);


for @tests -> $case {
    my $code_ref = $case.pop;
    my @array = $case.pop.list;
    say $case.pop, "\n";

    say "Standard Sort:\n";
    .say for @array.sort;

    say "\nNatural Sort:\n";
    .say for @array.sort: {.$code_ref};

    say "\n" ~ '*' x 40 ~ "\n";
}
