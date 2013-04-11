sub sma (Int $period where (* > 0)) returns Sub {
  my $sum = 0;
  my @a;
  return sub ($x) {
      @a.push: $x;
      $sum += $x;
      $sum -= @a.shift if @a > $period;
      return $sum / @a;
  }
}
