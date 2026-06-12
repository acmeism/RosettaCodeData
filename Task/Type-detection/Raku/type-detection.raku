sub type ($t) { say $t.raku, "\tis type: ", $t.WHAT }

# some content types
.&type for 1, 2.0, 3e0, 4i, π, Inf, NaN, 'String';

# some primitive container types
.&type for $, [ ], @, { }, %, (5 .. 7), (8 ... 10), /0/, {;}, sub {}, ( );

# undefined things
.&type for Any, Nil;

# user defined types
class my-type { };

my my-type $object;

$object.&type;
