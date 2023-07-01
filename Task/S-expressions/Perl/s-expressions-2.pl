my $s = sexpr(q{

((data "quoted data" 123 4.5)
 (data (!@# (4.5) "(more" "data)")))

});

# Dump structure
use Data::Dumper;
print Dumper $s;

# Convert back
print sexpr2txt($s)."\n";
