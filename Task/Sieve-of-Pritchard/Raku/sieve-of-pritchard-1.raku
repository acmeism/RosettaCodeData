unit sub MAIN($limit = 150);

my $maxS = 1;
my $length = 2;
my $p = 3;
my @s = ();

while $p*$p <= $limit {
  if $length < $limit {
    extend-to [$p*$length, $limit].min;
  }
  delete-multiples-of($p);
  $p = next(1);
}
if $length < $limit {
  extend-to $limit;
}

# Done, build the list of actual primes from the array
$p = 3;
my @primes = 2, |gather while $p <= $limit {
  take $p;
  $p = next($p);
};
say @primes;

exit;

sub extend-to($n) {
  my $w = 1;
  my $x = $length + 1;
  while $x <= $n {
     append $x;
     $w = next($w);
     $x = $length + $w;
  }
  $length = $n;
  if $length == $limit {
    append $limit+2;
  }
}

sub delete-multiples-of($p) {
  my $f = $p;
  while $p*$f <= $length {
    $f = next($f);
  }
  while $f > 1 {
    $f = prev($f);
    delete($p*$f);
  }
}

sub append($w) {
  @s[$maxS-1] = $w;
  @s[$w-2] = $maxS;
  $maxS = $w;
}

sub next($w) { @s[$w-1]; }
sub prev($w) { @s[$w-2]; }

sub delete($pf) {
  my $temp1 = @s[$pf-2];
  my $temp2 = @s[$pf-1];
  @s[$temp1-1] = $temp2;
  @s[($temp2-2)%@s] = $temp1;
}
