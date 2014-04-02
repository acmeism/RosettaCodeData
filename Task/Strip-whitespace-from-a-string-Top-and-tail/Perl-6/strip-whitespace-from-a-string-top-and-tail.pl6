my $s = "\r\n \t\x2029 Good Stuff \x202F\n";
say $s.trim;
say $s.trim.perl;
say $s.trim-leading.perl;
say $s.trim-trailing.perl;
