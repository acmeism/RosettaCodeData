use strict;
use warnings;
use List::Util;
use Parse::RecDescent;

my $g = Parse::RecDescent->new(<<'EOG');
  {
     my %atomic_weight = <H 1.008 C 12.011 O 15.999 Na 22.99 S 32.06>
  }

  weight   : compound         { $item[1] }
  compound : group(s)         { List::Util::sum( @{$item[1]} ) }
  group    : element /\d+/    { $item[1] * $item[2] }
           | element          { $item[1] }
  element  : /[A-Z][a-z]*/    { $atomic_weight{ $item[1] } }
           | "(" compound ")" { $item[2] }
EOG

for (<H H2 H2O Na2SO4 C6H12 COOH(C(CH3)2)3CH3>) {
    printf "%7.3f %s\n", $g->weight($_), $_
}
