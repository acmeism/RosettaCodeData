use Math::Pari qw/factorint/;
sub factor {
  my ($pn,$pc) = @{Math::Pari::factorint(shift)};
  return map { ($pn->[$_]) x $pc->[$_] } 0 .. $#$pn;
}
print "$_ = ", join(" x ", factor($_)), "\n" for 1000000000000000000 .. 1000000000000000010;
