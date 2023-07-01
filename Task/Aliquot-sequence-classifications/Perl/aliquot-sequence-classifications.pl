use ntheory qw/divisor_sum/;

sub aliquot {
  my($n, $maxterms, $maxn) = @_;
  $maxterms = 16 unless defined $maxterms;
  $maxn = 2**47 unless defined $maxn;

  my %terms = ($n => 1);
  my @allterms = ($n);
  for my $term (2 .. $maxterms) {
    $n = divisor_sum($n)-$n;
    # push onto allterms here if we want the cyclic term to display
    last if $n > $maxn;
    return ("terminates",@allterms, 0) if $n == 0;
    if (defined $terms{$n}) {
      return ("perfect",@allterms)  if $term == 2 && $terms{$n} == 1;
      return ("amicible",@allterms) if $term == 3 && $terms{$n} == 1;
      return ("sociable-".($term-1),@allterms) if $term >  3 && $terms{$n} == 1;
      return ("aspiring",@allterms) if $terms{$n} == $term-1;
      return ("cyclic-".($term-$terms{$n}),@allterms)   if $terms{$n} < $term-1;
    }
    $terms{$n} = $term;
    push @allterms, $n;
  }
  ("non-term",@allterms);
}

for my $n (1..10) {
  my($class, @seq) = aliquot($n);
  printf "%14d %10s [@seq]\n", $n, $class;
}
print "\n";
for my $n (qw/11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488 15355717786080/) {
  my($class, @seq) = aliquot($n);
  printf "%14d %10s [@seq]\n", $n, $class;
}
