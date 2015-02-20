sub combinations(Int $n, Int $k) {
    return ([],) unless $k;
    return if $k > $n || $n <= 0;
    my @c = ^$k;
    gather loop {
      take [@c];
      next if @c[$k-1]++ < $n-1;
      my $i = $k-2;
      $i-- while $i >= 0 && @c[$i] >= $n-($k-$i);
      last if $i < 0;
      @c[$i]++;
      while ++$i < $k { @c[$i] = @c[$i-1] + 1; }
    }
}
.say for combinations(5,3);
