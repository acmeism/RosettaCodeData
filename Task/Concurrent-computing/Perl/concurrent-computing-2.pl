use feature qw( say );
use Coro;
use Coro::Timer qw( sleep );

$_->join for map {
    async {
        sleep rand;
        say @_;
    } $_
} qw( Enjoy Rosetta Code );
