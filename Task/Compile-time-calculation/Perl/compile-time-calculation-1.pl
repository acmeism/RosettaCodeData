my $tenfactorial;
print "$tenfactorial\n";

BEGIN
   {$tenfactorial = 1;
    $tenfactorial *= $_ foreach 1 .. 10;}
