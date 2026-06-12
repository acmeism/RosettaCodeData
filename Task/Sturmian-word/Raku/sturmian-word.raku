# 20240215 Raku programming solution

sub chenfoxlyndonfactorization(Str $s) {
 sub sturmian-word($m, $n) {
   return sturmian-word($n, $m).trans('0' => '1', '1' => '0') if $m > $n;
   my ($res, $k, $prev) = '', 1, 0;
   while ($k * $m) % $n > 0 {
      my $curr = ($k * $m) div $n;
      $res ~= $prev == $curr ?? '0' !! '10';
      $prev = $curr;
      $k++;
   }
   return $res;
}

sub fib-word($n) {
   my ($Sn_1, $Sn) = '0', '01';
   for 2..$n { ($Sn, $Sn_1) = ($Sn~$Sn_1, $Sn) }
   return $Sn;
}

my $fib = fib-word(7);
my $sturmian = sturmian-word(13, 21);
say "{$sturmian} <== 13/21" if $fib.substr(0, $sturmian.chars) eq $sturmian;

sub cfck($a, $b, $m, $n, $k) {
   my (@p, @q) := [0, 1], [1, 0];
   my $r = (sqrt($a) * $b + $m) / $n;
   for ^$k {
      my $whole = $r.Int;
      my ($pn, $qn) = $whole * @p[*-1] + @p[*-2], $whole * @q[*-1] + @q[*-2];
      @p.push($pn);
      @q.push($qn);
      $r = 1/($r - $whole);
   }
   return [@p[*-1], @q[*-1]];
}

my $cfck-result = cfck(5, 1, -1, 2, 8);
say "{sturmian-word($cfck-result[0], $cfck-result[1])} <== 1/phi (8th convergent golden ratio)";
