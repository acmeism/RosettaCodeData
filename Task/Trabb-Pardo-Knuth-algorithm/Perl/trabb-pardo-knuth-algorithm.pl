print "Enter 11 numbers:\n";
for ( 1..11 ) {
   $number = <STDIN>;
   chomp $number;
   push @sequence, $number;
}

for $n (reverse @sequence) {
   my $result = sqrt( abs($n) ) + 5 * $n**3;
   printf "f( %6.2f ) %s\n", $n, $result > 400 ? "  too large!" : sprintf "= %6.2f", $result
}
