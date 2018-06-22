use ntheory qw/factor vecmax/;
use threads;
use threads::shared;
my @results :shared;

my $tnum = 0;
$_->join() for
  map { threads->create('tfactor', $tnum++, $_) }
  (qw/576460752303423487 576460752303423487 576460752303423487 112272537195293
  115284584522153 115280098190773 115797840077099 112582718962171 299866111963290359/);

my $lmf = vecmax( map { $_->[1] } @results );
print "Largest minimal factor of $lmf found in:\n";
print "  $_->[0] = [@$_[1..$#$_]]\n" for grep { $_->[1] == $lmf } @results;

sub tfactor {
  my($tnum, $n) = @_;
  push @results, shared_clone([$n, factor($n)]);
}
