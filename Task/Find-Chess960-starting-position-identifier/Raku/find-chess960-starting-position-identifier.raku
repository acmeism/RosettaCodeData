sub c960-spid($array) {
    # standardize on letters for easier processing
    my $ascii = $array.trans('♜♞♝♛♚♖♘♗♕♔' => 'RNBQK');

    # error-checking
    my %Names = <Q Queen K King R Rook N Knight B Bishop>;
    return 'Illegal position: should have exactly eight pieces' unless 8 == $ascii.chars;
    return 'Illegal position: Bishops not on opposite colors.'  unless 1 == sum $ascii.indices('B').map(* % 2);
    return 'Illegal position: King not between rooks.'          unless $ascii ~~ /'R' .* 'K' .* 'R'/;
    for <K 1 Q 1 B 2 N 2 R 2> -> $piece, $count {
        return "Illegal position: should have exactly $count %Names{$piece}\(s\)\n" unless $count == $ascii.indices($piece)
    }

    # Work backwards through the placement rules.
    # King and rooks are forced during placement, so ignore them.

    # 1. Figure out which knight combination was used:
    my @knights = $ascii.subst(/<[QB]>/, '', :g).indices('N');
    my $knight = combinations(5,2).kv.grep( -> $i, @c { @c eq @knights } ).flat.first;

    # 2. Then which queen position:
    my $queen = $ascii.subst('B', '', :g).index('Q');

    # 3. Finally the two bishops:
    my @bishops = $ascii.indices('B');
    my ($dark,$light) = (@bishops.first %% 2 ?? @bishops !! @bishops.reverse) Xdiv 2;

    $ascii.trans('RNBQK' => '♖♘♗♕♔') ~ ' ' ~ 4 × (4 × (6 × $knight + $queen) + $dark) + $light;
}

say .&c960-spid for <♖♘♗♕♔♗♘♖ ♛♞♜♝♝♞♚♜ RQNBBKRN RNQBBKRN QNBRBNKR>;
