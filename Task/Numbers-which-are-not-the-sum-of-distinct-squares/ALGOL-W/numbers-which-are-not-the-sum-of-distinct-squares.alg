begin comment find the integers that can't be expressed as the sum of distinct squares
              it can be proved that if 120-324 can be expressed as the sum of distinct
              squares then all integers greater than 129 can be so expressed
              (see the link in the Wren sample) so we need to check that 129-324 can
              be so expressed and find the numbers below 129 that can't be so expressed
            ;
    integer MAX_NUMBER, MAX_SQUARE;
    MAX_NUMBER := 324;
    MAX_SQUARE := entier( sqrt( MAX_NUMBER ) );

    begin
        logical array isSum  ( 0 :: MAX_NUMBER );
        integer array square ( 0 :: MAX_SQUARE );
        integer unformable;

        procedure flagSum ( integer value currSum, sqPos ) ; begin
             integer nextSum;
             nextSum := currSum + square( sqPos );
             if nextSum <= MAX_NUMBER then begin
                isSum( nextSum ) := true;
                for i := sqPos + 1 until MAX_SQUARE do flagSum( nextSum, i )
             end of_nextSum_le_MAX_NUMBER
        end flagSum ;

        for i := 0 until MAX_NUMBER do isSum(  i ) := false;
        for i := 0 until MAX_SQUARE do square( i ) := i * i;
        for i := 0 until MAX_SQUARE do flagSum( 0, i );
        % show the numbers that can't be formed from a sum of distinct squares %
        % and check 129-324 can be so formed %
        unformable := 0;
        for i := 0 until MAX_NUMBER do
        if not isSum( i ) then begin
            writeon( i_w := 4, s_w := 0, i );
            unformable := unformable + 1;
            if unformable rem 12 = 0 then write();
            if i > 128 then write( i_w := 1, s_w := 0, "**** unexpected unformable number: ", i )
        end if_not_isSum__i
    end
end.
