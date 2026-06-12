sub sort_within_string ( $_ is copy ) {
    constant @lexographic_order = sort *.fc, map &chr, 1..255;

    return join '', gather for @lexographic_order -> $l {
        my $count = s:g/$l//;
        take $l x $count;
        LAST { warn "Original string had non-ASCII chars: {.raku}" if .chars }
    }
}
say trim .&sort_within_string for q:to/END/.lines;
The quick brown fox jumps over the lazy dog, apparently
Now is the time for all good men to come to the aid of their country.
END
