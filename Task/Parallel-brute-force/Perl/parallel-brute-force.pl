use Digest::SHA qw/sha256_hex/;
use threads;
use threads::shared;
my @results :shared;

print "$_ : ",join(" ",search($_)), "\n" for (qw/
  1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad
  3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b
  74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f
/);


sub search {
  my $hash = shift;
  @results = ();
  $_->join() for map { threads->create('tsearch', $_, $hash) } 0..25;
  return @results;
}

sub tsearch {
  my($tnum, $hash) = @_;
  my $s = chr(ord("a")+$tnum) . "aaaa";

  for (1..456976) { # 26^4
    push @results, $s if sha256_hex($s) eq $hash;
    $s++;
  }
}
