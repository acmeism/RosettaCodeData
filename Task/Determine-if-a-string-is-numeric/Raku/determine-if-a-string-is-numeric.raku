sub is-number-w-ws( Str $term --> Bool ) { # treat Falsey strings as numeric
    $term.Numeric !~~ Failure;
}

sub is-number-wo-ws( Str $term --> Bool ) { # treat Falsey strings as non-numeric
    ?($term ~~ / \S /) && $term.Numeric !~~ Failure;
}

say "               Coerce     Don't coerce";
say '    String   whitespace    whitespace';
printf "%10s  %8s  %11s\n",
"<$_>", .&is-number-w-ws, .&is-number-wo-ws for
(|<1 1.2 1.2.3 -6 1/2 12e B17 1.3e+12 1.3e12 -2.6e-3 zero 0x 0xA10 0b1001 0o16
0o18 2+5i True False Inf NaN 0x10.50 0b102 0o_5_3 ௫௯>, '  12  ', '1 1 1', '', ' ' ).map: *.Str;
