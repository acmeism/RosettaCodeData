sub pascal
# Prints out $n rows of Pascal's triangle. It returns undef for
# failure and 1 for success.
  {my $n = shift;
   $n < 1 and return undef;
   print "1\n";
   $n == 1 and return 1;
   my @last = (1);
   foreach my $row (1 .. $n - 1)
      {my @this = map {$last[$_] + $last[$_ + 1]} 0 .. $row - 2;
       @last = (1, @this, 1);
       print join(' ', @last), "\n";}
   return 1;}
