use MONKEY-SEE-NO-EVAL;
sub to_tree_string_eval ( @xs --> Array ) {
    my @gap = [ |@xs, 0 ]  Z-  [ 0, |@xs ];

    my @open  = @gap.map( '[' x  * );
    my @close = @gap.map( ']' x -* );

    my @wrapped = [Z~] @open, @xs, @close.skip;

    return EVAL @wrapped.join(',').subst(:g, ']]', '],]') || '[]';
}
my @tests = (), (1, 2, 4), (3, 1, 3, 1), (1, 2, 3, 1), (3, 2, 1, 3), (3, 3, 3, 1, 1, 3, 3, 3);
say .Str.fmt( '%15s => ' ), .&to_tree_string_eval for @tests;
