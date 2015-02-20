my $s      = "rosetta code phrase reversal";
my $rev_s  = reverse($s);
my $rev_ew = join(" ", reverse split(/ /,reverse $s));
my $rev_wo = join(" ", reverse split(/ /,$s));

printf "0. %-20s: %s\n", "input",               $s;
printf "1. %-20s: %s\n", "string reversed",     $rev_s;
printf "2. %-20s: %s\n", "each word reversed",  $rev_ew;
printf "3. %-20s: %s\n", "word-order reversed", $rev_wo;
