# 20240213 Raku programming solution

sub chenfoxlyndonfactorization(Str $s) {
   my ($n, $i, @factorization) = $s.chars, 1;
   while $i <= $n {
      my ($j, $k) = $i X+ (1, 0);
      while $j <= $n && substr($s, $k-1, 1) <= substr($s, $j-1, 1) {
         substr($s, $k-1, 1) < substr($s, $j++ -1, 1) ?? ( $k = $i ) !! $k++;
      }
      while $i <= $k {
         @factorization.push: substr($s, $i-1, $j-$k);
         $i += $j - $k
      }
   }
   die unless $s eq [~] @factorization;
   return @factorization
}

my $m = "0";
for ^7 { $m ~= $m.trans('0' => '1', '1' => '0') }
say chenfoxlyndonfactorization($m);
