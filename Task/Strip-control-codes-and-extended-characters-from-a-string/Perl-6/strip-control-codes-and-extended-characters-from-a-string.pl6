my $str = (0..400).roll(80)».chr.join;

say $str;
say $str.subst(/<:Cc>/,      '', :g); # unicode property: control character
say $str.subst(/<-[\ ..~]>/, '', :g);
