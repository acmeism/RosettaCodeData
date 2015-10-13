my $str = 'this is an example for huffman encoding';
my %enc = huffman $str;
my %dec = %enc.invert;
say $str;
my $huf = %enc{$str.comb}.join;
say $huf;
my $rx = join('|', map { "'" ~ .key ~ "'" }, %dec);
$rx = EVAL '/' ~ $rx ~ '/';
say $huf.subst(/<$rx>/, -> $/ {%dec{~$/}}, :g);
