my @Example = ();

sub check-Sequence($pos, @seq, $n, $minLen --> List)  {
   if ($pos > $minLen or @seq[0] > $n) {
      return $minLen, 0;
   } elsif (@seq[0] == $n) {
      @Example = @seq;
      return $pos, 1;
   } elsif ($pos < $minLen) {
      return try-Permutation 0, $pos, @seq, $n, $minLen;
   } else {
      return $minLen, 0;
   }
}

multi sub try-Permutation($i, $pos, @seq, $n, $minLen --> List) {
   return $minLen, 0 if $i > $pos;
   my @res1 = check-Sequence $pos+1, (@seq[0]+@seq[$i],@seq).flat, $n, $minLen;
   my @res2 = try-Permutation $i+1, $pos, @seq, $n, @res1[0];
   if (@res2[0] < @res1[0]) {
      return @res2[0], @res2[1];
   } elsif (@res2[0] == @res1[0]) {
      return @res2[0], @res1[1]+@res2[1];
   } else {
      note "Error in try-Permutation";
      return 0, 0;
   }
}

multi sub try-Permutation($x, $minLen --> List) {
   return try-Permutation 0, 0, [1], $x, $minLen;
}

sub find-Brauer($num, $minLen, $nbLimit) {
   my ($actualMin, $brauer) = try-Permutation $num, $minLen;
   say "\nN = ", $num;
   say "Minimum length of chains : L($num) = $actualMin";
   say "Number of minimum length Brauer chains : ", $brauer;
   say "Brauer example : ", @Example.reverse if $brauer > 0;
   @Example = ();
   if ($num ≤ $nbLimit) {
      my $nonBrauer = find-Non-Brauer $num, $actualMin+1, $brauer;
      say "Number of minimum length non-Brauer chains : ", $nonBrauer;
      say "Non-Brauer example : ", @Example if $nonBrauer > 0;
      @Example = ();
   } else {
      say "Non-Brauer analysis suppressed";
   }
}

sub is-Addition-Chain(@a --> Bool) {
   for 2 .. @a.end -> $i {
      return False if @a[$i] > @a[$i-1]*2 ;
      my $ok = False;
      for $i-1 … 0 -> $j {
         for $j … 0 -> $k {
            { $ok = True; last } if @a[$j]+@a[$k] == @a[$i];
         }
      }
      return False unless $ok;
   }

   @Example = @a unless @Example or is-Brauer @a;
   return True;
}

sub is-Brauer(@a --> Bool) {
   for 2 .. @a.end -> $i {
      my $ok = False;
      for $i-1 … 0 -> $j {
         { $ok = True; last } if @a[$i-1]+@a[$j] == @a[$i];
      }
      return False unless $ok;
   }
   return True;
}

sub find-Non-Brauer($num, $len, $brauer --> Int) {
   my @seq   = flat 1 .. $len-1, $num;
   my $count = is-Addition-Chain(@seq) ?? 1 !! 0;

   sub next-Chains($index) {
      loop {
         next-Chains $index+1 if $index < $len-1;
         return if @seq[$index]+$len-1-$index ≥ @seq[$len-1];
         @seq[$index]++;
         for $index^..^$len-1 { @seq[$_] = @seq[$_-1] + 1 }
         $count++ if is-Addition-Chain @seq;
      }
   }

   next-Chains 2;
   return $count - $brauer;
}

say "Searching for Brauer chains up to a minimum length of 12:";
find-Brauer $_, 12, 79 for 7, 14, 21, 29, 32, 42, 64 #, 47, 79, 191, 382, 379, 379, 12509 # un-comment for extra-credit
