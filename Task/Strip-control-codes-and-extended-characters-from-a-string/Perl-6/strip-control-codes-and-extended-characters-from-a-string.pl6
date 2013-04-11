my $str = (0..400).roll(80)».chr.join;

say $str;
say $str.subst(/<[ ^@..^_ ]>/, '', :g);
say $str.subst(/<-[ \ ..~ ]>/, '', :g);
