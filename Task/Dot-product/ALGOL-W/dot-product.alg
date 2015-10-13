begin
    % computes the dot product of two equal length integer vectors            %
    % (single dimension arrays ) the length of the vectors must be specified  %
    % in length.                                                              %
    integer procedure integerDotProduct( integer array a ( * )
                                       ; integer array b ( * )
                                       ; integer value length
                                       ) ;
    begin
        integer product;
        product := 0;
        for i := 1 until length do product := product + ( a(i) * b(i) );
        product
    end integerDotProduct ;

    % declare two vectors of length 3                                         %
    integer array v1, v2 ( 1 :: 3 );
    % initialise the vectors                                                  %
    v1(1) :=  1; v1(2) :=  3; v1(3) := -5;
    v2(1) :=  4; v2(2) := -2; v2(3) := -1;
    % output the dot product                                                  %
    write( integerDotProduct( v1, v2, 3 ) )
end.
