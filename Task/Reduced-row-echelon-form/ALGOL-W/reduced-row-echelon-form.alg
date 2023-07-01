begin
    % replaces M with it's reduced row echelon form              %
    % M should have bounds ( 0 :: rMax, 0 :: cMax )              %
    procedure toReducedRowEchelonForm ( real    array M ( *, * )
                                      ; integer value rMax, cMax
                                      ) ;
    begin
        integer lead;
        lead := 0;
        for r := 0 until rMax do begin
            integer i;
            if lead > cMax then goto done;
            i := r;
            while M( i, lead ) = 0 do begin
                i := i + 1;
                if rMax = i then begin
                    i    := r;
                    lead := lead + 1;
                    if cMax = lead then goto done
                end if_rowCount_eq_i
            end while_M_i_lead_eq_0 ;
            % Swap rows i and r %
            for c := 0 until cMax do begin
                real t;
                t         := M( i, c );
                M( i, c ) := M( r, c );
                M( r, c ) := t
            end swap_rows_i_and_r ;
            If M( r, lead ) not = 0 then begin
                % divide row r by M[r, lead] %
                real rLead;
                rLead := M( r, lead );
                for c := 0 until cMax do M( r, c ) := M( r, c ) / rLead
            end if_M_r_lead_ne_0 ;
            for i := 0 until rMax do begin
                if i not = r then begin
                    % Subtract M[i, lead] multiplied by row r from row i %
                    real iLead;
                    iLead := M( i, lead );
                    for c := 0 until cMax do M( i, c ) := M( i, c ) - ( iLead * M( r, c ) )
                end if_i_ne_r
            end for_i ;
            lead := lead + 1
        end for_r ;
done:
    end toReducedRowEchelonForm ;
    % test the toReducedRowEchelonForm procedure %
    begin
        real array m( 0 :: 2, 0 :: 3 );
        M( 0, 0 ) :=  1; M( 0, 1 ) :=  2; M( 0, 2 ) := -1; M( 0, 3 ) :=  -4;
        M( 1, 0 ) :=  2; M( 1, 1 ) :=  3; M( 1, 2 ) := -1; M( 1, 3 ) := -11;
        M( 2, 0 ) := -2; M( 2, 1 ) :=  0; M( 2, 2 ) := -3; M( 2, 3 ) :=  22;
        toReducedRowEchelonForm( M, 2, 3 );
        r_format := "A"; s_w := 0; r_w := 6; r_d := 1; % set output formating %
        for r := 0 until 2 do begin
            write( M( r, 0 ) );
            for c := 1 until 3 do writeon( " ", M( r, c ) );
        end for_r
    end
end.
