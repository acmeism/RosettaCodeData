begin % -- solve the 4 rings or 4 squares puzzle i.e., find solutions to the  %
      % -- equations: a + b = b + c + d = d + e + f = f + g                   %
      % -- where a, b, c, d, e, f, g in lo : hi ( not necessarily unique )    %
      % -- depending on show, the solutions will be printed or not            %
    procedure fourRings ( integer value lo, hi; logical value allowDuplicates, show ) ;
    begin
        integer solutions, width, maxLimit;
        solutions       := 0;
        % -- calculate field width for printinhg solutions %
        width    := 1;
        maxLimit := abs ( if abs lo > abs hi then lo else hi );
        while maxLimit > 0 do begin
            width    := width + 1;
            maxLimit := maxLimit div 10
        end while_maxLimit_gt_0 ;
        % -- find solutions %
        for a := lo until hi do begin
            for b := lo until hi do begin
                if allowduplicates or a not = b then begin
                    integer t;
                    t := a + b;
                    for c := lo until hi do begin
                        if allowDuplicates
                        or ( a not = c and b not = c )
                        then begin
                            integer d;
                            d := t - ( b + c );
                            if  d >= lo and d <= hi
                            and ( allowduplicates
                                or ( a not = d and b not = d and c not = d )
                                )
                            then begin
                                for e := lo until hi do begin
                                    if allowDuplicates
                                    or ( a not = e and b not = e and c not = e and d not = e )
                                    then begin
                                        integer f, g;
                                        g := d + e;
                                        f := t - g;
                                        if  f >= lo and f <= hi
                                        and g >= lo and g <= hi
                                        and ( allowDuplicates
                                            or (   a not = f and b not = f and c not = f
                                               and d not = f and e not = f
                                               and a not = g and b not = g and c not = g
                                               and d not = g and e not = g and f not = g
                                               )
                                            )
                                        then begin
                                            solutions := solutions + 1;
                                            if show then write( i_w := width, s_w := 0, a, b, c, d, e, f, g )
                                        end
                                    end
                                end for_e
                            end
                        end
                    end for_c
                end
            end for_b
        end for_a ;
        write( i_w := 1, s_w := 0, solutions, if allowDuplicates then " non-unique" else " unique", " solutions in ", lo, " to ", hi );
        write()
    end % -- fourRings % ;

    % -- find the solutions as required for the task %
    fourRings( 1, 7, false, true  );
    fourRings( 3, 9, false, true  );
    fourRings( 0, 9, true,  false )
end.
