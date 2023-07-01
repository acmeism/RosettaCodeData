sub curry{
  my ($func, @args) = @_;

  sub {
    #This @_ is later
    &$func(@args, @_);
  }
}

sub plusXY{
  $_[0] + $_[1];
}

my $plusXOne = curry(\&plusXY, 1);
print &$plusXOne(3), "\n";
