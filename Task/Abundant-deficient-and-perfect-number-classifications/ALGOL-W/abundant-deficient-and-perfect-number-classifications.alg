begin % count abundant, perfect and deficient numbers up to 20 000        %
    integer MAX_NUMBER;
    MAX_NUMBER := 20000;
    begin
        integer array pds ( 1 :: MAX_NUMBER );
        integer aCount, dCount, pCount, dSum;
        % construct a table of proper divisor sums                        %
        pds( 1 ) := 0;
        for i := 2 until MAX_NUMBER do pds( i ) := 1;
        for i := 2 until MAX_NUMBER do begin
            for j := i + i step i until MAX_NUMBER do pds( j ) := pds( j ) + i
        end for_i ;
        aCount := dCount := pCOunt := 0;
        for i := 1 until 20000 do begin
            dSum := pds( i );
            if      dSum > i then aCount := aCount + 1
            else if dSum < i then dCount := dCOunt + 1
            else %  dSum = i    % pCount := pCount + 1
        end for_i ;
        write( "Abundant  numbers up to 20 000: ", aCount );
        write( "Perfect   numbers up to 20 000: ", pCount );
        write( "Deficient numbers up to 20 000: ", dCount )
    end
end.
