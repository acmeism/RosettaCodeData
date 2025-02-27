begin % Solve the McNuggets problem: find the largest n <= 100 for which there %
      % are no non-negative integers x, y, z such that 6x + 9y + 20z = n       %
    integer maxNuggets;
    maxNuggets := 100;
    begin
        logical array isSum ( 0 :: maxNuggets );
        integer largest;
        % find the numbers that can be formed                                  %
        for x := 0 step 6 until maxNuggets do begin
            for y := x step 9 until maxNuggets do begin
                for z := y step 20 until maxNuggets do isSum( z ) := true
            end for_y
        end for_x ;
        % show the highest number that cannot be formed                        %
        largest := -1;
        for i := maxNuggets step -1 until 0 do begin
            if not isSum( i ) then begin
                largest := i;
                goto foundLargest
            end if_not_isSum_i
        end for_i;
foundLargest:
        write( i_w := 1, s_w := 0, "The largest non-McNugget number is: ", largest )
    end
end.
