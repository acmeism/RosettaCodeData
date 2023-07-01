use warnings;
use strict;
use Math::BigRat;

sub farey {
  my $n = shift;
  my %v;
  for my $k (1 .. $n) {
    for my $i (0 .. $k) {
      $v{ Math::BigRat->new("$i/$k")->bstr }++;
    }
  }
  my @f = sort {$a <=> $b }
          map { Math::BigRat->new($_) }
          keys %v;
  @f;
}

for (1 .. 11) {
  my @f = map { join "/", $_->parts }   # Force 0/1 and 1/1
          farey($_);
  print "F$_: [@f]\n";
}
for (1 .. 10) {
  my @f = farey(100*$_);
  print "F${_}00: ", scalar(@f), " members\n";
}
