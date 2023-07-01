my $s = "\r\n \t\x2029 Good Stuff \x202F\n";
say $s.trim;
say $s.trim.raku;
say $s.trim-leading.raku;
say $s.trim-trailing.raku;
