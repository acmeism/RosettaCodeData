for ('pi=3.14159265358979323846264338327950288419716939937510582097494459231', {:6at, :5by, :ins(' ')}),
    ('The author has two Z$100000000000000 Zimbabwe notes (100 trillion).', {:ins<.>}),
    '-in Aus$+1411.8millions',
    '===US$0017440 millions=== (in 2000 dollars)',
    '123.e8000 is pretty big.',
    'The land area of the earth is  57268900(29% of the surface)  square miles.',
    'Ain\'t no numbers in this here words, nohow, no way, Jose.',
    'James was never known as  0000000007',
    'Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.',
    '   $-140000±100  millions.',
    '6/9/1946 was a good year for some.'
    {
        say "Before: ", .[0];
        say " After: ", .[1] ?? .[0].&commatize( |.[1] ) !! .&commatize;
    }

sub commatize($s, :$at = 0, :$ins = ',', :$by = 3) {
    $s.subst: :continue($at), :1st, / <[1..9]> <[0..9]>* /,
        *.flip.comb(/<{ ".**1..$by" }>/).join($ins).flip;
}
