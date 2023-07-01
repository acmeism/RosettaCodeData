% generate an ascii table for chars 32 - 127            %
for i := 32 until 32 + 15 do begin
    write();
    for c := i step 16 until i + ( 16 * 5 ) do begin
        writeon( i_w := 3, s_w := 0, c, ": " );
        if      c =  32 then writeon( "Spc ")
        else if c = 127 then writeon( "Del " )
        else                 writeon( code( c ), "   " )
    end for_ach
end for_i.
