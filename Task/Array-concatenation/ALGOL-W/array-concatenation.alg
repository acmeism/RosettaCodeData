begin
    integer array a ( 1 :: 5 );
    integer array b ( 2 :: 4 );
    integer array c ( 1 :: 8 );

    % concatenates the arrays a and b into c                        %
    % the lower and upper bounds of each array must be specified in %
    % the corresponding *Lb and *Ub parameters                      %
    procedure arrayConcatenate ( integer array a ( * )
                               ; integer value aLb, aUb
                               ; integer array b ( * )
                               ; integer value bLb, bUb
                               ; integer array c ( * )
                               ; integer value cLb, cUb
                               ) ;
        begin
            integer cPos;
            assert( ( cUb - cLb ) + 1 >= ( ( aUb + bUb ) - ( aLb + bLb ) ) - 2 );
            cPos := cLb;
            for aPos := aLb until aUb do begin
                c( cPos ) := a( aPos );
                cPos := cPos + 1
            end for_aPos ;
            for bPos := bLb until bUb do begin
                c( cPos ) := b( bPos );
                cPos := cPos + 1
            end for_bPos
        end arrayConcatenate ;

    % test arrayConcatenate                                          %
    for aPos := 1 until 5 do a( aPos ) := aPos;
    for bPos := 2 until 4 do b( bPos ) := - bPos;
    arrayConcatenate( a, 1, 5, b, 2, 4, c, 1, 8 );
    for cPos := 1 until 8 do writeon( i_w := 1, s_w := 1, c( cPos ) )

end.
