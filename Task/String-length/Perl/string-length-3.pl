use v5.12;
my $string = "\x{1112}\x{1161}\x{11ab}\x{1100}\x{1173}\x{11af}";  # 한글
my $len;
$len++ while ($string =~ /\X/g);
printf "Grapheme length: %d\n", $len;
