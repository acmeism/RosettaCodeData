# 20201120 Raku programming solution

my \MAXITER = 151;

sub minkowski(\x) {

   return x.floor + minkowski( x - x.floor ) if x > 1 || x < 0 ;

   my $y = my $p = x.floor;
   my ($q,$s,$d) = 1 xx 3;
   my $r = $p + 1;

   loop {
      last if ( $y + ($d /= 2)  == $y )        ||
              ( my $m = $p + $r) <  0 | $p < 0 ||
              ( my $n = $q + $s) <  0           ;
      x < $m/$n ?? ( ($r,$s) = ($m, $n) ) !! ( $y += $d; ($p,$q) = ($m, $n) );
   }
   return $y + $d
}

sub minkowskiInv($x is copy) {

   return $x.floor + minkowskiInv($x - $x.floor) if  $x > 1 || $x < 0 ;

   return $x if $x == 1 || $x == 0 ;

   my @contFrac = 0;
   my $i = my $curr = 0 ; my $count = 1;

   loop {
      $x *= 2;
      if $curr == 0 {
         if $x < 1 {
            $count++
         } else {
            $i++;
            @contFrac.append: 0;
            @contFrac[$i-1] = $count;
            ($count,$curr) = 1,1;
            $x--;
         }
      } else {
         if $x > 1 {
            $count++;
            $x--;
         } else {
            $i++;
            @contFrac.append: 0;
            @contFrac[$i-1] = $count;
            ($count,$curr) = 1,0;
         }
      }
      if $x == $x.floor { @contFrac[$i] = $count ; last }
      last if $i == MAXITER;
    }
    my $ret = 1 / @contFrac[$i];
    loop (my $j = $i - 1; $j ≥ 0; $j--) { $ret = @contFrac[$j] + 1/$ret }
    return 1 / $ret
}

printf "%19.16f %19.16f\n", minkowski(0.5*(1 + 5.sqrt)), 5/3;
printf "%19.16f %19.16f\n", minkowskiInv(-5/9), (13.sqrt-7)/6;
printf "%19.16f %19.16f\n", minkowski(minkowskiInv(0.718281828)),
   minkowskiInv(minkowski(0.1213141516171819))
