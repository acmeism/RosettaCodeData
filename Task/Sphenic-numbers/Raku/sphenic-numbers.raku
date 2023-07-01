use Prime::Factor;
use List::Divvy;
use Lingua::EN::Numbers;

my @sphenic = lazy (^Inf).hyper(:200batch).grep: { my @pf = .&prime-factors; +@pf == 3 and +@pf.unique == 3 };
my @triplets = lazy (^Inf).grep( { @sphenic[$_]+2 == @sphenic[$_+2] } ).map: {(@sphenic[$_,$_+1,$_+2])}

say "Sphenic numbers less than 1,000:\n" ~
    @sphenic.&upto(1e3).batch(15)».fmt("%3d").join: "\n";

say "\nSphenic triplets less than 10,000:";
.say for @triplets.&before(*.[2] > 1e4);

say "\nThere are {(+@sphenic.&upto(1e6)).&comma} sphenic numbers less than {1e6.Int.&comma}";
say "There are {(+@triplets.&before(*.[2] > 1e6)).&comma} sphenic triplets less than {1e6.Int.&comma}";
say "The 200,000th sphenic number is {@sphenic[2e5-1].&comma} ({@sphenic[2e5-1].&prime-factors.join(' × ')}).";
say "The 5,000th sphenic triplet is ({@triplets[5e3-1].join(', ')})."
