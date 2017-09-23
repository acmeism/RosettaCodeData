use Lingua::EN::Numbers::Cardinal;

put join "\n", .&cardinal, .&cardinal(:improper) with -7/4;

printf "%-7s : %19s : %s\n", $_, cardinal($_), cardinal($_, :denominator(16)) for 1/16, 2/16 ... 1;

put join "\n", .&cardinal, .&cardinal-year, .&ordinal, .&ordinal-digit with 1999;

.&cardinal.put for 6.022e23, 42000, π;
