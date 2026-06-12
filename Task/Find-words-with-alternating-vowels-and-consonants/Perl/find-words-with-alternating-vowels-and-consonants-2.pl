$vowels = 'aeiou';
$v = qr/[$vowels]/;
$c = qr/[^$vowels]/;

/^ ( ($c$v)+ $c? | ($v$c)+ $v? ) $/ix and say for grep { /.{10}/ } split "\n",  do { (@ARGV, $/) = 'unixdict.txt'; <> };
