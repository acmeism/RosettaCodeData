begin
    % show possible department number allocations for police, sanitation and fire departments %
    % the police department number must be even, all department numbers in the range 1 .. 7   %
    % the sum of the department numbers must be 12                                            %
    integer MAX_DEPARTMENT_NUMBER, DEPARTMENT_SUM;
    MAX_DEPARTMENT_NUMBER :=  7;
    DEPARTMENT_SUM        := 12;
    write( "police sanitation fire" );
    for police := 2 step 2  until MAX_DEPARTMENT_NUMBER do begin
        for sanitation := 1 until MAX_DEPARTMENT_NUMBER do begin
            IF sanitation not = police then begin
                integer fire;
                fire := ( DEPARTMENT_SUM - police ) - sanitation;
                if  fire > 0 and fire <= MAX_DEPARTMENT_NUMBER and fire not = sanitation and fire not = police then begin
                    write( s_w := 0, i_w := 6, police, i_w := 11, sanitation, i_w := 5, fire )
                end if_valid_combination
            end if_sanitation_ne_police
        end for_sanitation
    end for_police
end.
