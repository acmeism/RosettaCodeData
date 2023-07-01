sub tokenize {
    my ($string, $sep, $esc) = (shift, quotemeta shift, quotemeta shift);

    my @fields = split /$esc . (*SKIP)(*FAIL) | $sep/sx, $string, -1;
    return map { s/$esc(.)/$1/gsr } @fields;
}
