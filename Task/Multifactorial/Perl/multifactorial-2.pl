use ntheory qw/vecprod/;

sub mfac {
  my($n,$d) = @_;
  vecprod(map { $n - $_*$d } 0 .. int(($n-1)/$d));
}

for my $degree (1..5) {
  say "$degree: ",join(" ",map{mfac($_,$degree)} 1..10);
}
