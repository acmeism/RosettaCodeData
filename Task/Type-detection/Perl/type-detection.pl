$scalar    = 1;
@array     = (1, 2);
%hash      = ('a' => 1);
$regex     = qr/foo.*bar/;
$reference = \%hash;
sub greet { print "Hello world!" };
$subref    = \&greet;

$fmt = "%-11s is type:  %s\n";
printf $fmt, '$scalar',    ref(\$scalar);
printf $fmt, '@array',     ref(\@array);
printf $fmt, '%hash',      ref(\%hash);
printf $fmt, '$regex',     ref( $regex);
printf $fmt, '$reference', ref(\$reference);
printf $fmt, '$subref',    ref( $subref);
