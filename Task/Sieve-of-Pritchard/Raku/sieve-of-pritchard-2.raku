unit sub MAIN($limit = 150);

class Wheel {
  has $.members is rw;
  has $.length is rw;
  method extend(*@limits) {
    my @members = $.members.keys;
    for @members -> $w {
      my $n = $w + $.length;
      while $n <= @limits.all {
        $.members.set($n);
        $n += $.length;
      }
    }
    $.length = @limits.min;
  }
}

# start with W₀=({1},1)
my $wheel = Wheel.new: :members(SetHash(1)), :length(1);
my $prime = 2;
my @primes = ();

while $prime * $prime <= $limit {
  if $wheel.length < $limit {
    $wheel.extend($prime*$wheel.length, $limit);
  }
  for $wheel.members.keys.sort(-*) -> $w {
    $wheel.members.unset($prime * $w);
  }
  @primes.push: $prime;
  $prime = $prime == 2 ?? 3 !! $wheel.members.keys.grep(*>1).sort[0];
}

if $wheel.length < $limit {
  $wheel.extend($limit);
}
@primes.append:  $wheel.members.keys.grep: * != 1;
say @primes.sort;
