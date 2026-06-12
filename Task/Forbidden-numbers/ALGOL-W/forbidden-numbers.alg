begin % find some forbidden numbers: numbers that cannot be formed by        %
      % summing fewer than four squares                                      %
    % returns TRUE if n is a Forbidden numbr, FALSE otherwise                %
    %         based on the Wren version of the example at oeis.org/A004215   %
    logical procedure isForbidden ( integer value n ) ;
            begin
               integer m, p4;
                m  := n;
                p4 := 1;
                while m > 1 and m rem 4 = 0 do begin
                    m  := m div 4;
                    p4 := p4 * 4
                end while_m_gt_1_and_m_rem_4_eq_0 ;
                ( n div p4 ) rem 8 = 7
            end isForbidden ;
    begin % show the first 50 forbidden numbers and forbidden number counts %
        integer fCount, nextToShow;
        fCount     :=   0;
        nextToShow := 500;
        for i := 1 until 500000000 do begin
            if isForbidden( i ) then begin
                fCount := fCount + 1;
                if fCount <= 50 then begin
                    writeon( i_w := 4, s_w := 0, " ", i );
                    if fCount rem 10 = 0 then write()
                end if_fCount_le_50
            end if_isForbidden ;
            if i = nextToShow then begin
                write( i_w := 8, s_w := 0, "There are ", fCount, " Forbidden numbers up to "
                     , i_w := 1, i
                     );
                nextToShow := nextToShow * 10
            end if_i_eq_nextToShow
        end for_i
    end
end.
