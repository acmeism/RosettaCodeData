sub MAIN ($filename, UInt $top = 10) {
    my $file = $filename.IO.slurp.lc.subst(/ (<[\w]-[_]>'-')\n(<[\w]-[_]>) /, {$0 ~ $1}, :g );
    my @matcher =
        rx/ <[a..z]>+ /,    # simple 7-bit ASCII
        rx/ \w+ /,          # word characters with underscore
        rx/ <[\w]-[_]>+ /,  # word characters without underscore
        rx/ [<[\w]-[_]>+]+ % < ' - '- > /  # word characters without underscore but with hyphens and contractions
    ;
    for @matcher -> $reg {
        say "\nTop $top using regex: ", $reg.raku;
	    my @words = $file.comb($reg).Bag.sort(-*.value)[^$top];
	    my $length = max @words».key».chars;
        printf "%-{$length}s %d\n", .key, .value for @words;
    }
}
