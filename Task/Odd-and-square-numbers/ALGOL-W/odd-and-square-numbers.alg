begin % print odd squares between 100 and 1000 %
    integer oddSquare, nextGap;
    oddSquare := 1;
    nextGap   := 8;
    while oddSquare < 100 do begin
        oddSquare := oddSquare + nextGap;
        nextGap   := nextGap + 8
    end while_oddSuare_lt_100 ;
    while oddSquare < 1000 do begin
        writeon( i_w := s_w := 1, oddSquare );
        oddSquare := oddSquare + nextGap;
        nextGap   := nextGap + 8
    end while_oddSquare_lt_1000
end.
