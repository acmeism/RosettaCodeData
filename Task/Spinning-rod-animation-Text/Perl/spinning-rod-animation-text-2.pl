$|=1;
binmode STDOUT, ":utf8";

while () {
  for (map { $_ + 1 } 0x1F310 .. 0x1F317) {
    # creating array of sequential Unicode codepoints for the emoji;
    # it's equal to qw[🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔 🌕  ] but comes handy for
    # implementing clock faces or any other codepoint ranges.
    select undef, undef, undef, 0.25;
    # all the magic of this thing; switches between three file handles every 0.25s
    print "\r @{[chr]}"
    # string/variable interpolation;
    # (1) chr without param works on `$_`
    # (2) `[]` creates a singleton list
    # (3) `@{}` dereferences the created list.
  }
}
