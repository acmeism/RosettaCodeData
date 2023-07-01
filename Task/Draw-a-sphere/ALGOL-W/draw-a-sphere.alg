begin
    % draw a sphere                                                                         %
    % returns the next integer larger than x or x if x is an integer                        %
    integer procedure ceil( real value x ) ;
    begin
        integer tmp;
        tmp := truncate( x );
        if tmp not = x then tmp + 1 else tmp
    end ciel ;
    % returns the absolute value of the dot product of x and y or 0 if it is not negative   %
    real procedure dot( real array x, y ( * ) ) ;
    begin
        real tmp;
        tmp := x( 1 ) * y( 1 ) + x( 2 ) * y( 2 ) + x( 3 ) * y( 3 );
        if tmp < 0 then - tmp else 0
    end dot ;
    % normalises the vector v                                                               %
    procedure normalize( real array v ( * ) ) ;
    begin
        real tmp;
        tmp := sqrt( v( 1 ) * v( 1 ) + v( 2 ) * v( 2 ) + v( 3 ) * v( 3 ) );
        for i := 1 until 3 do v( i ) := v( i ) / tmp
    end normalize ;
    % draws a sphere using ASCII art                                                        %
    procedure drawSphere( real       value radius
                        ; integer    value k
                        ; real       value ambient
                        ; real       array light    ( * )
                        ; string(10) value shades
                        ) ;
    begin
        real array  vec ( 1 :: 3 );
        integer     intensity, maxShades;
        real        diameter, r2;
        maxShades   := 9;
        diameter    :=      2 * radius;
        r2          := radius * radius;
        for i := entier( - radius ) until ceil( radius ) do begin
            real         x, x2;
            integer      linePos;
            string(256)  line;
            linePos := 0;
            x       := i + 0.5;
            x2      := x * x;
            line    := "";
            for j := entier( - diameter ) until ceil( diameter ) do begin
                real y, y2;
                y  := j / 2 + 0.5;
                y2 := y * y;
                if x2 + y2 <= r2 then begin
                    real     b, dp;
                    vec( 1 )  := x;
                    vec( 2 )  := y;
                    vec( 3 )  := sqrt( r2 - x2 - y2 );
                    normalize( vec );
                    dp        := dot( light, vec );
                    b         := dp;
                    for p := 2 until k do b := b * dp;
                    b         := b + ambient;
                    intensity := round( ( 1 - b ) * maxShades );
                    if intensity < 0         then intensity := 0;
                    if intensity > maxShades then intensity := maxShades;
                    line( linePos // 1 ) := shades( intensity // 1 );
                    end
                else line( linePos // 1 ) := " "
                ;
                if linePos < 255 then linePos := linePos + 1
            end for_j ;
            write( s_w := 0, line( 0 // 1 ) );
            for c := 1 until if linePos > 255 then 255 else linePos - 1 do writeon( s_w := 0, line( c // 1 ) )
        end for_i
    end drawSphere ;
    % test drawSphere                                                                       %
    begin
        real array light ( 1 :: 3 );
        integer     maxShades;
        light( 1 )  :=  30;
        light( 2 )  :=  30;
        light( 3 )  := -59;
        normalize( light );
        drawSphere( 20, 4, 0.1, light, ".:!*oe#%&@" );
        drawSphere( 10, 2, 0.4, light, ".:!*oe#%&@" )
    end test
end.
