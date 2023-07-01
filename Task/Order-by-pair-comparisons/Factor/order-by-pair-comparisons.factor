USING: formatting io kernel math.order prettyprint qw sorting ;

qw{ violet red green indigo blue yellow orange }
[ "Is %s > %s? (y/n) " printf readln "y" = +gt+ +lt+ ? ] sort .
