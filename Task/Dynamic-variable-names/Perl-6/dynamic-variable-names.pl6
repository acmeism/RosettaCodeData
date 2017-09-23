our $our-var = 'The our var';
my  $my-var  = 'The my var';

my $name  = prompt 'Variable name: ';
my $value = $::($name); # use the right sigil, etc

put qq/Var ($name) starts with value ｢$value｣/;

$::($name) = 137;

put qq/Var ($name) ends with value ｢{$::($name)}｣/;
