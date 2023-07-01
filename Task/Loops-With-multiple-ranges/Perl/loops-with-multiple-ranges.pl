use constant   one =>  1;
use constant three =>  3;
use constant seven =>  7;
use constant     x =>  5;
use constant    yy => -5; # 'y' conflicts with use as equivalent to 'tr' operator (a carry-over from 'sed')
use constant     z => -2;

my $prod = 1;

sub from_to_by {
    my($begin,$end,$skip) = @_;
    my $n = 0;
    grep{ !($n++ % abs $skip) } $begin <= $end ? $begin..$end : reverse $end..$begin;
}

sub commatize {
    (my $s = reverse shift) =~ s/(.{3})/$1,/g;
    $s =~ s/,(-?)$/$1/;
    $s = reverse $s;
}

for my $j (
    from_to_by(-three,3**3,three),
    from_to_by(-seven,seven,x),
    555 .. 550 - yy,
    from_to_by(22,-28,-three),
    1927 .. 1939,
    from_to_by(x,yy,z),
    11**x .. 11**x+one,
   ) {
     $sum  += abs($j);
     $prod *= $j if $j and abs($prod) < 2**27;
}

printf "%-8s %12s\n", 'Sum:',     commatize $sum;
printf "%-8s %12s\n", 'Product:', commatize $prod;
