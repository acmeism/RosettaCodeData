sub area-by-shoelace(@p) {
    (^@p).map({@p[$_;0] * @p[($_+1)%@p;1] - @p[$_;1] * @p[($_+1)%@p;0]}).sum.abs / 2
}

say area-by-shoelace( [ (3,4), (5,11), (12,8), (9,5), (5,6) ] );
