use threads;
use Time::HiRes qw(sleep);

$_->join for map {
    threads->create(sub {
        sleep rand;
        print shift, "\n";
    }, $_)
} qw(Enjoy Rosetta Code);
