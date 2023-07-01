# 20201013 Raku programming solution

use BigRoot;
use Rat::Precise;
use experimental :cached;

BigRoot.precision = 75 ;
my $Precision     = 70 ;
my $AGcache       =  0 ;

sub postfix:<!>(Int $n --> Int) is cached { [*] 1 .. $n }

sub Integral(Int $n --> Int) is cached {
   (2⁵*(6*$n)! * (532*$n² + 126*$n + 9)) div (3*($n!)⁶)
}

sub A-G(Int $n --> FatRat) is cached { # Almkvist-Giullera
   Integral($n).FatRat / (10**(6*$n + 3)).FatRat
}

sub Pi(Int $n --> Str) {
   (1/(BigRoot.newton's-sqrt: $AGcache += A-G $n)).precise($Precision)
}

say "First 10 integer portions : ";
say $_, "\t", Integral $_ for ^10;

my $target = Pi my $Nth = 0;

loop { $target eq ( my $next = Pi ++$Nth ) ?? ( last ) !! $target = $next }

say "π to $Precision decimal places is :\n$target"
