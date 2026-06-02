sub Mcnugget-number(*@counts) {
   my int @valid = @counts.grep(* > 0).unique.sort;
   return '∞' unless @valid;
   return '∞' if ([gcd] @valid) > 1;
   return 0 if (my int $min = @valid[0]) == 1;

   my int $max = @valid[*-1];
   my int @ring = 1, |(0 xx $max-1);
   my int ($streak, $largest-non, $ptr) = 1, 0, 0;

   loop (my int $n = 1; ; $n++) {
      $ptr = 0 if ++$ptr == $max;
      my Bool $is-reachable = False;

      for @valid -> int $c {
         last if $c > $n;
         my int $lookback = ($ptr - $c) % $max;
         if @ring[$lookback] { $is-reachable = True and last }
      }
      ( @ring[$ptr] = $is-reachable ).Bool
         ?? ( return $largest-non if ++$streak >= $min )
         !! ($streak, $largest-non) = 0, $n
   }
}

for (6,9,20), (6,7,20), (1,3,20), (10,5,18), (5,17,44), (2,4,6), (3,6,15),
    (12,14,17),(12,13,34),(5,9,21),(10,18,21),(71,98,99),(4,30,16),(12,12,13),
    (6,15,1),(11,13,17,19)
-> $counts {
   my $res = Mcnugget-number(|$counts);
   put "Maximum non-Mcnugget using {$counts.join(', ')} is: $res";
}
