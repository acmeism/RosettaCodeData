begin
    % record to hold details of a Heronian triangle %
    record Heronian ( integer a, b, c, area, perimeter );
    % returns the details of the Heronian Triangle with sides a, b, c or nil if it isn't one %
    reference(Heronian) procedure tryHt( integer value a, b, c ) ;
    begin
        real                s, areaSquared, area;
        reference(Heronian) t;
        s           := ( a + b + c ) / 2;
        areaSquared := s * ( s - a ) * ( s - b ) * ( s - c );
        t           := null;
        if areaSquared > 0 then begin
            % a, b, c does form a triangle %
            area    := sqrt( areaSquared );
            if entier( area ) = area then begin
                % the area is integral so the triangle is Heronian %
                t := Heronian( a, b, c, entier( area ), a + b + c )
            end
        end;
        t
    end tryHt ;

    % returns the GCD of a and b %
    integer procedure gcd( integer value a, b ) ; if b = 0 then a else gcd( b, a rem b );

    % prints the details of the Heronian triangle t %
    procedure htPrint( reference(Heronian) value t ) ; write( i_w := 4, s_w := 1, a(t), b(t), c(t), area(t), "     ", perimeter(t) );
    % prints headings for the Heronian Triangle table %
    procedure htTitle ; begin write( "   a    b    c area perimeter" ); write( "---- ---- ---- ---- ---------" ) end;

    begin
        % construct ht as a table of the Heronian Triangles with sides up to 200 %
        reference(Heronian) array ht ( 1 :: 1000 );
        reference(Heronian)       t;
        integer                   htCount;

        htCount := 0;
        for c := 1 until 200 do begin
            for b := 1 until c do begin
                for a := 1 until b do begin
                    if gcd( gcd( a, b ), c ) = 1 then begin
                        t := tryHt( a, b, c );
                        if t not = null then begin
                            htCount       := htCount + 1;
                            ht( htCount ) := t
                        end
                    end
                end
            end
        end;

        % sort the table on ascending area, perimeter and max side length %
        % note we constructed the triangles with c as the longest side %
        begin
            integer             lower, upper;
            reference(Heronian) k, h;
            logical             swapped;
            lower := 1;
            upper := htCount;
            while begin
                upper   := upper - 1;
                swapped := false;
                for i := lower until upper do begin
                    h := ht( i     );
                    k := ht( i + 1 );
                    if area(k) < area(h) or (   area(k) =  area(h)
                                            and (  perimeter(k) <  perimeter(h)
                                                or (   perimeter(k) = perimeter(h)
                                                   and c(k)         < c(h)
                                                   )
                                                )
                                            )
                    then begin
                        ht( i     ) := k;
                        ht( i + 1 ) := h;
                        swapped     := true;
                    end
                end;
                swapped
            end
            do  begin end;
        end;

        % display the triangles %
        write( "There are ", htCount, " Heronian triangles with sides up to 200" );
        htTitle;
        for htPos := 1 until 10 do htPrint( ht( htPos ) );
        write( " ..." );
        write( "Heronian triangles with area 210:" );
        htTitle;
        for htPos := 1 until htCount do begin
            reference(Heronian) t;
            t := ht( htPos );
            if area(t) = 210 then htPrint( t )
        end
    end
end.
