# 20201127 Raku programming solution

my ( $st, $count, $i, $pow, $digits, $offset, $lastSelf, $done, @selfs) =
     now,      0,  1,   10,       1,       9,         0, False;

# while ( $count < 1e8 ) {
until $done {
   my $isSelf = True;
   my $sum    = (my $start = max ($i-$offset), 0).comb.sum;
   loop ( my $j = $start; $j < $i; $j+=1 ) {
      if $j+$sum == $i { $isSelf = False and last }
      ($j+1)%10 != 0 ?? ( $sum+=1 ) !! ( $sum = ($j+1).comb.sum ) ;
   }
   if $isSelf {
      $count+=1;
      $lastSelf = $i;
      if $count ≤ 50 {
         @selfs.append: $i;
         if $count == 50 {
            say "The first 50 self numbers are:\n", @selfs;
            $done = True;
         }
      }
   }
   $i+=1;
   if $i % $pow == 0 {
      $pow *= 10;
      $digits+=1 ;
      $offset = $digits * 9
   }
}

# say "The 100 millionth self number is ", $lastSelf;
# say "Took ", now - $st, " seconds."
