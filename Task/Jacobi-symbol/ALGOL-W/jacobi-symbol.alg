begin % Jacobi symbol %

    integer procedure jacobi( integer value aIn, nIn ) ;
        if nIn <= 0 or not odd( nIn ) then begin
            write( "The 'n' parameter of jacobi must be an odd positive integer." );
            0
            end
        else begin
            integer a, n, js;
            a := aIn rem nIn; n := nIn; js := 1;
            while a not = 0 do begin
                while a rem 2 = 0 do begin
                    integer nm8;
                    a := a div 2;
                    nm8 := n rem 8;
                    if nm8 = 3 or nm8 = 5 then js := - js;
                end while_a_rem_2_eq_0 ;
                begin integer t; t := a; a := n; n := t end;
                if a rem 4 = 3 and n rem 4 = 3 then js := - js;
                a := a rem n
            end;
            if n = 1 then js else 0
        end jacobi ;

    write( "Table of jacobi(a, n):" );;
    write( "n/a   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15" );
    write( "---------------------------------------------------------------" );
    for n := 1 step 2 until 29 do begin
        write( i_w := 3, s_w := 0, n );
        for a := 1 until 15 do writeon( i_w := 4, s_w := 0, jacobi( a, n ) );
    end

end.
