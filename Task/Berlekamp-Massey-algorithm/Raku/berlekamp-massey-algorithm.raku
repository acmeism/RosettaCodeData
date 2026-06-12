# 20250510 Raku programming solution

constant MOD = 2;

sub berlekamp_massey(@a) {
   my ($n, $w, $delta, @ans_coef, @lst) = @a.elems - 1, 0;
   for 1 .. $n -> $i {
      my $tmp = 0;
      for ^@ans_coef.elems -> $j {
         if $i - 1 - $j >= 1 {
            $tmp = ($tmp + @a[$i - 1 - $j] * @ans_coef[$j]) % MOD;
         }
      }
      my $discrepancy = (@a[$i] - $tmp + MOD) % MOD;
      next if $discrepancy == 0;
      if $w == 0 {
         @ans_coef = (0 xx $i);
         $w = $i;
         $delta = $discrepancy;
         next;
      }
      my @now = @ans_coef;
      my $mul = $discrepancy * expmod($delta, MOD - 2, MOD);
      my $needed_len = @lst.elems + $i - $w;
      if @ans_coef.elems < $needed_len {
         @ans_coef.append: (0 xx ($needed_len - @ans_coef.elems));
      }
      if $i - $w - 1 >= 0 {
         @ans_coef[$i - $w - 1] = (@ans_coef[$i - $w - 1] + $mul) % MOD;
      }
      for ^@lst.elems -> $j {
         my $idx = $i - $w + $j;
         if $idx < @ans_coef.elems {
            my $term_to_subtract = ($mul * @lst[$j]) % MOD;
            @ans_coef[$idx] = (@ans_coef[$idx] - $term_to_subtract + MOD) % MOD;
         }
      }
      if @ans_coef.elems > @now.elems {
         @lst = @now;
         $w = $i;
         $delta = $discrepancy;
      }
   }
   return @ans_coef.map: { ($^x + MOD) % MOD };
}

sub calculate_term($m, @coef, @h) {
   if $m < @h.elems                { return (@h[$m] + MOD) % MOD }
   if ( my $k = @coef.elems ) == 0 { return 0 }
   my @p_coeffs = (1, |@coef);
   sub poly_mul(@a, @b, $degree_k, @p_poly) {
      my @res = (0 xx (2 * $degree_k));
      for ^$degree_k X ^$degree_k -> ($i, $j) {
         next if @a[$i] == 0;
         @res[$i + $j] = (@res[$i + $j] + @a[$i] * @b[$j]) % MOD;
      }
      for ( 2 * $degree_k - 1 ... $degree_k ) -> $i {
         next if @res[$i] == 0;
         my $term = @res[$i];
         @res[$i] = 0;
         for 0 .. $degree_k -> $j {
            if ( my $idx = $i - $j ) >= 0 {
               @res[$idx] = (@res[$idx] + $term * @p_poly[$j]) % MOD;
            }
         }
      }
      return @res[0 ... ^$degree_k];
   }
   my @f = (1, |(0 xx ($k - 1)));
   my @g = $k == 1 ?? (@p_coeffs[1],) !! (0, 1, |(0 xx ($k - 2)));
   my $power = $m;
   while $power > 0 {
      unless $power %% 2 { @f = poly_mul(@f, @g, $k, @p_coeffs) }
      @g = poly_mul(@g, @g, $k, @p_coeffs);
      $power div= 2;
   }
   my $final_ans = 0;
   for ^$k -> \k {
      if k+1 < @h.elems { $final_ans = ($final_ans + @h[k+1] * @f[k]) % MOD }
   }
   return ($final_ans + MOD) % MOD;
}

sub solve {
   my @h_input = 0,0,1,1,0,1,0;
   my $n = @h_input.elems;
   my @h = 0, |@h_input;
   my @ans_coef = berlekamp_massey(@h);
   say @ans_coef.map({ ($^x + MOD) % MOD }).Str;
   my $m = 10;
   my $result = calculate_term($m, @ans_coef, @h);
   say ($result + MOD) % MOD;
}

solve();
