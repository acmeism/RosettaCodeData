use v5.36;
use List::Util 'uniq';
use ntheory qw<factor>;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 5); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my @sphenic  = grep { my @pf = factor($_); 3 == @pf and 3 == uniq(@pf) } 1..1e6;
my @triplets =  map { @sphenic[$_..$_+2] } grep { ($sphenic[$_]+2) == $sphenic[$_+2] } 0..$#sphenic-2;

say "Sphenic numbers less than 1,000:\n" . table 15, grep { $_ < 1000 } @sphenic;
say "Sphenic triplets less than 10,000:";
say table 3, grep { $_ < 10000 } @triplets;

printf "There are %s sphenic numbers less than %s\n",  comma(scalar @sphenic),     comma 1e6;
printf "There are %s sphenic triplets less than %s\n", comma(scalar(@triplets)/3), comma 1e6;
printf "The 200,000th sphenic number is %s\n",         comma $sphenic[2e5-1];
printf "The 5,000th sphenic triplet is %s\n",          join ' ', map {comma $_} @triplets[map {3*4999 + $_} 0,1,2];
