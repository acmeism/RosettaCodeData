use POSIX qw(ceil floor);

sub fivenum {
   my(@array) = @_;
   my $n = scalar @array;
   die "No values were entered into fivenum!" if $n == 0;
   my @x = sort {$a <=> $b} @array;
   my $n4 = floor(($n+3)/2)/2;
   my @d = (1, $n4, ($n +1)/2, $n+1-$n4, $n);
   my @sum_array;
   for my $e (0..4) {
      my $floor = floor($d[$e]-1);
      my $ceil  =  ceil($d[$e]-1);
      push @sum_array, (0.5 * ($x[$floor] + $x[$ceil]));
   }
   return @sum_array;
}

my @x = (15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43);
my @tukey = fivenum(\@x);
say join (',', @tukey);
#----------
@x = (36, 40, 7, 39, 41, 15),
@tukey = fivenum(\@x);
say join (',', @tukey);
#----------
@x = (0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,
     0.73438555, -0.03035726,  1.46675970, -0.74621349, -0.72588772,
     0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
     0.66206163,  1.04312009, -0.10305385,  0.75775634,  0.32566578);
@tukey = fivenum(\@x);
say join (',', @tukey);
