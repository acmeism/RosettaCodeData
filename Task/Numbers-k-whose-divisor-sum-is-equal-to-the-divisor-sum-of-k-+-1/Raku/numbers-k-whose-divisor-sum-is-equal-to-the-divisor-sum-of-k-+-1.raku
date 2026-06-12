use Prime::Factor;
use Lingua::EN::Numbers;

say ++$, ': ', .&comma for (^Inf).hyper.grep( {
    state $next = .&sigma-sum;
    my $test = $next == my $this = ($_ + 1).&sigma-sum;
    $next = $this;
    $test
})[^50];
