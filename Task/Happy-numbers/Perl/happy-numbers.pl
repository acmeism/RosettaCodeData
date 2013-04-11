use List::Util qw(sum);

sub is_happy ($)
 {for (my ($n, %seen) = shift ;; $n = sum map {$_**2} split //, $n)
     {$n == 1 and return 1;
      $seen{$n}++ and return 0;}}

for (my ($n, $happy) = (1, 0) ; $happy < 8 ; ++$n)
   {is_happy $n or next;
    print "$n\n";
    ++$happy;}
