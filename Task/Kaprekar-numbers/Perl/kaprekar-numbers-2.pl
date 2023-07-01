use ntheory qw/fordivisors gcd invmod/;

my %kap;
for my $n (1..15) {
  my $np = int(10**$n)-1;
  fordivisors {
    my($d, $dp) = ($_, $np/$_);
    $kap{ $dp==1 ? $d : invmod($d,$dp)*$d }++
      if  gcd($d, $dp) == 1;
  } $np;
}
my @kap = sort { $a<=>$b } keys %kap;
for my $n (6 .. 14) {
  my $np = int(10**$n)-1;
  printf "Kaprekar numbers <= 10^%2d:  %5d\n",
         $n, scalar(grep { $_ <= $np } @kap);
}
