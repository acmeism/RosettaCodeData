sub soundex ($name --> Str) {
    my $first = substr($name,0,1).uc;
    gather {
        take $first;
        my $fakefirst = '';
        $fakefirst = "de " if $first ~~ /^ <[AEIOUWH]> /;
        "$fakefirst$name".lc.trans('wh' => '') ~~ /
            ^
            [
                [
                | <[ bfpv     ]>+ { take 1 }
                | <[ cgjkqsxz ]>+ { take 2 }
                | <[ dt       ]>+ { take 3 }
                | <[ l        ]>+ { take 4 }
                | <[ mn       ]>+ { take 5 }
                | <[ r        ]>+ { take 6 }
                ]
            || .
            ]+
            $ { take 0,0,0 }
        /;
    }.flat.[0,2,3,4].join;
}

for < Soundex     S532
      Example     E251
      Sownteks    S532
      Ekzampul    E251
      Euler       E460
      Gauss       G200
      Hilbert     H416
      Knuth       K530
      Lloyd       L300
      Lukasiewicz L222
      Ellery      E460
      Ghosh       G200
      Heilbronn   H416
      Kant        K530
      Ladd        L300
      Lissajous   L222
      Wheaton     W350
      Ashcraft    A261
      Burroughs   B620
      Burrows     B620
      O'Hara      O600 >
-> $n, $s {
    my $s2 = soundex($n);
    say $n.fmt("%16s "), $s, $s eq $s2 ?? " OK" !! " NOT OK $s2";
}
