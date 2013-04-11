$max= $ARGV[0];
@primes= ();
@tested= (1);
$j= 1;
while ($j < $max) {
   next if $tested[$j++];
   push @primes, $j;
   for ($k= $j; $k <= $max; $k+=$j) {
      $tested[$k-1]= 1;
   }
}
print "@primes\n";
