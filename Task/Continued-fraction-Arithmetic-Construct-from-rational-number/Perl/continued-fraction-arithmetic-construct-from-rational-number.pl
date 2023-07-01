$|=1;

sub rc2f {
  my($num, $den) = @_;
  return sub { return unless $den;
               my $q = int($num/$den);
               ($num, $den) = ($den, $num - $q*$den);
               $q; };
}

sub rcshow {
  my $sub = shift;
  print "[";
  my $n = $sub->();
  print "$n" if defined $n;
  print "; $n" while defined($n = $sub->());
  print "]\n";
}

rcshow(rc2f(@$_))
   for ([1,2],[3,1],[23,8],[13,11],[22,7],[-151,77]);
print "\n";
rcshow(rc2f(@$_))
   for ([14142,10000],[141421,100000],[1414214,1000000],[14142136,10000000]);
print "\n";
rcshow(rc2f(314285714,100000000));
