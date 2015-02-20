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
