use Math::Pari qw/:int factorint isprime/;

# Convert Math::Pari's format into simple vector
sub factor {
  my ($pn,$pc) = @{Math::Pari::factorint(shift)};
  map { ($pn->[$_]) x $pc->[$_] } 0 .. $#$pn;
}

for (100 .. 150) {
  next unless isprime($_);
  my $p = 2 ** $_ - 1;
  print "2^$_-1: ", join(" ", factor($p)), "\n";
}
