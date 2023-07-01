use ntheory qw/forsetproduct/;
forsetproduct { say "@_" } [1,2,3],[qw/a b c/],[qw/@ $ !/];

use Set::Product qw/product/;
product { say "@_" } [1,2,3],[qw/a b c/],[qw/@ $ !/];

use Math::Cartesian::Product;
cartesian { say "@_" } [1,2,3],[qw/a b c/],[qw/@ $ !/];

use Algorithm::Loops qw/NestedLoops/;
NestedLoops([[1,2,3],[qw/a b c/],[qw/@ $ !/]], sub { say "@_"; });
