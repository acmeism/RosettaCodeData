begin % find some sub-unit squares: squares which are still squares when 1 %
      % is subtracted from each of their digits                            %
      % the sub-unit squares must end in 36 (see task discussion) and so   %
      % the square formed by subtracting 1 from each digit must end in 25  %
      % so, as with the J sample, we start with the "25" square and test   %
      % the incremented square                                             %

    integer suCount, addOnes, powerOf10, n;

    % find the sub unit squares - note that 1 is a special case            %
    writeon( "1" );
    suCount   :=  1;
    addOnes   :=  1;
    powerOf10 := 10;
    n         := -5;
    while suCount < 5 do begin
        integer sq, addUnitSq;
        n  := n + 10;
        sq := n * n;
        while sq > powerOf10 do begin
            % the square has more digits than the previous one             %
            powerOf10 := powerOf10 * 10;
            addOnes   := ( addOnes * 10 ) + 1
        end;
        addUnitSq := sq + addOnes;
        if addUnitSq < powerOf10 then begin
            integer root;
            % squaring the number with one added to the digits has the     %
            % same number of digits as the original square                 %
            root := entier( sqrt( addUnitSq ) );
            if root * root = addUnitSq then begin
                logical noZeros;
                integer v;
                % the add unit square is actually a square                 %
                % make sure there are no 0s in the add unit square as they %
                % can't be decremented to a positive digit                 %
                noZeros := true;
                v       := addUnitSq;
                while noZeros and v > 0 do begin
                    noZeros := v rem 10 not = 0;
                    v := v div 10
                end;
                if noZeros then begin
                    writeon( i_w := 1, s_w := 0, " ", addUnitSq );
                    suCount := suCount + 1
                end if_noZeros
            end if_addUnitSq_is_a_square
        end if_addUnitSq_lt_powerOf10
    end while_suCount_lt_5
end.
