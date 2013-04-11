my $s = "\r\n \t\x2029 Good Stuff \x2028\n";
say $s.trim.perl;
say $s.trim-leading.perl;
say $s.trim-trailing.perl;
