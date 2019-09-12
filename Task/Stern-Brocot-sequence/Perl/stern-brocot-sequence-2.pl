use ntheory qw/gcd vecsum vecfirst/;

sub stern_diatomic {
  my ($p,$q,$i) = (0,1,shift);
  while ($i) {
    if ($i & 1) { $p += $q; } else { $q += $p; }
    $i >>= 1;
  }
  $p;
}

my @s = map { stern_diatomic($_) } 1..15;
print "First fifteen: [@s]\n";
@s = map { my $n=$_; vecfirst { stern_diatomic($_) == $n } 1..10000 } 1..10;
print "Index of 1-10 first occurrence: [@s]\n";
print "Index of 100 first occurrence: ", (vecfirst { stern_diatomic($_) == 100 } 1..10000), "\n";
print "The first 999 consecutive pairs are ",
 (vecsum( map { gcd(stern_diatomic($_),stern_diatomic($_+1)) } 1..999 ) == 999)
 ? "all coprime.\n" : "NOT all coprime!\n";
