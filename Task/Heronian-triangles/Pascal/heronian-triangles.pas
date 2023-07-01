program heronianTriangles ( input, output );
type
    (* record to hold details of a Heronian triangle *)
    Heronian    = record a, b, c, area, perimeter : integer end;
    refHeronian = ^Heronian;

var

    ht             : array [ 1 .. 1000 ] of refHeronian;
    htCount, htPos : integer;
    a, b, c, i     : integer;
    lower, upper   : integer;
    k, h, t        : refHeronian;
    swapped        : boolean;

    (* returns the details of the Heronian Triangle with sides a, b, c or nil if it isn't one *)
    function tryHt( a, b, c : integer ) : refHeronian;
    var
        s, areaSquared, area : real;
        t                    : refHeronian;
    begin
        s           := ( a + b + c ) / 2;
        areaSquared := s * ( s - a ) * ( s - b ) * ( s - c );
        t           := nil;
        if areaSquared > 0 then begin
            (* a, b, c does form a triangle *)
            area    := sqrt( areaSquared );
            if trunc( area ) = area then begin
                (* the area is integral so the triangle is Heronian *)
                new(t);
                t^.a := a; t^.b := b; t^.c := c; t^.area := trunc( area ); t^.perimeter := a + b + c
            end
        end;
        tryHt := t
    end (* tryHt *) ;

    (* returns the GCD of a and b *)
    function gcd( a, b : integer ) : integer;
    begin
        if b = 0 then gcd := a else gcd := gcd( b, a mod b )
    end (* gcd *) ;

    (* prints the details of the Heronian triangle t *)
    procedure htPrint( t : refHeronian ) ; begin writeln( t^.a:4, t^.b:5, t^.c:5, t^.area:5, t^.perimeter:10 ) end;
    (* prints headings for the Heronian Triangle table *)
    procedure htTitle ; begin writeln( '   a    b    c area perimeter' ); writeln( '---- ---- ---- ---- ---------' ) end;

begin
    (* construct ht as a table of the Heronian Triangles with sides up to 200 *)
    htCount := 0;
    for c := 1 to 200 do begin
        for b := 1 to c do begin
            for a := 1 to b do begin
                if gcd( gcd( a, b ), c ) = 1 then begin
                    t := tryHt( a, b, c );
                    if t <> nil then begin
                        htCount       := htCount + 1;
                        ht[ htCount ] := t
                    end
                end
            end
        end
    end;

    (* sort the table on ascending area, perimeter and max side length *)
    (* note we constructed the triangles with c as the longest side *)
    lower := 1;
    upper := htCount;
    repeat
        upper   := upper - 1;
        swapped := false;
        for i := lower to upper do begin
            h := ht[ i     ];
            k := ht[ i + 1 ];
            if ( k^.area < h^.area ) or (   ( k^.area =  h^.area )
                                        and (  ( k^.perimeter <  h^.perimeter )
                                            or (   ( k^.perimeter = h^.perimeter )
                                               and ( k^.c <  h^.c )
                                               )
                                            )
                                        )
            then begin
                ht[ i     ] := k;
                ht[ i + 1 ] := h;
                swapped     := true
            end
        end;
    until not swapped;

    (* display the triangles *)
    writeln( 'There are ', htCount:1, ' Heronian triangles with sides up to 200' );
    htTitle;
    for htPos := 1 to 10 do htPrint( ht[ htPos ] );
    writeln( ' ...' );
    writeln( 'Heronian triangles with area 210:' );
    htTitle;
    for htPos := 1 to htCount do begin
        t := ht[ htPos ];
        if t^.area = 210 then htPrint( t )
    end
end.
