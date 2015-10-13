begin

    % computes the sum and product of intArray                               %
    % the results are returned in sum and product                            %
    % the bounds of the array must be specified in lb and ub                 %
    procedure sumAndProduct( integer array  intArray ( * )
                           ; integer value  lb, ub
                           ; integer result sum, product
                           ) ;
    begin

        sum     := 0;
        product := 1;

        for i := lb until ub
        do begin
            sum     :=     sum + intArray( i );
            product := product * intArray( i );
        end for_i ;

    end sumAndProduct ;

    % test the sumAndProduct procedure                                       %
    begin

        integer array v   ( 1 :: 10 );
        integer sum, product;

        for i := 1 until 10 do v( i ) := i;

        sumAndProduct( v, 1, 10, sum, product );
        write( sum, product );
    end
end.
