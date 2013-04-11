my @list = ( 1, 2, 3 );

my ( $sum, $prod ) = ( 0, 1 );
$sum  += $_ foreach @list;
$prod *= $_ foreach @list;
