use v6;

sub endsWithOne($n --> Bool) {
   my $digit;
   my $sum = 0;
   my $nn = $n;
   loop {
      while ($nn > 0) {
         $digit = $nn % 10;
         $sum += $digit²;
         $nn = $nn div 10;
      }
      ($sum == 1) and return True;
      ($sum == 89) and return False;
      $nn = $sum;
      $sum = 0;
   }
}

my @ks = (7, 8, 11, 14, 17);

for @ks -> $k {
   my @sums is default(0) = 1,0;
   my $s;
   for (1 .. $k) -> $n {
      for ($n*81 ... 1) -> $i {
         for (1 .. 9) -> $j {
            $s = $j²;
            if ($s > $i) { last };
            @sums[$i] += @sums[$i-$s];
         }
      }
   }
   my $count1 = 0;
   for (1 .. $k*81) -> $i { if (endsWithOne($i)) {$count1 += @sums[$i]} }
   my $limit = 10**$k - 1;
   say "For k = $k in the range 1 to $limit";
   say "$count1 numbers produce 1 and ",$limit-$count1," numbers produce 89";
}
