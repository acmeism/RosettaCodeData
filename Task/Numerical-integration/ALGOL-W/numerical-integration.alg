begin % compare some numeric integration methods                             %

    long real procedure leftRect ( long real procedure f
                                 ; long real value     a, b
                                 ; integer   value     n
                                 ) ;
    begin
        long real h, sum, x;
        h   := (b - a) / n;
        sum := 0;
        x   := a;
        while x <= b - h do begin
            sum := sum + (h * f(x));
            x   := x + h
        end;
        sum
    end leftRect ;

    long real procedure rightRect ( long real procedure f
                                  ; long real value     a, b
                                  ; integer   value     n
                                  ) ;
    begin
        long real h, sum, x;
        h   := (b - a) / n;
        sum := 0;
        x   := a + h;
        while x <= b do begin
            sum := sum + (h * f(x));
            x   := x + h
        end;
        sum
    end rightRect ;

    long real procedure midRect ( long real procedure f
                                ; long real value     a, b
                                ; integer   value     n
                                ) ;
    begin
        long real h, sum, x;
        h   := (b - a) / n;
        sum := 0;
        x   := a;
        while x <= b - h do begin
            sum := sum + h * f(x + h / 2);
            x   := x + h
        end;
        sum
    end midRect ;

    long real procedure trapezium ( long real procedure f
                                  ; long real value     a, b
                                  ; integer   value     n
                                  ) ;
    begin
        long real h, sum, x;
        h   := (b - a) / n;
        sum := f(a) + f(b);
        x   := 1;
        while x <= n - 1 do begin
            sum := sum + 2 * f(a + x * h );
            x   := x + 1
        end;
        (b - a) / (2 * n) * sum
    end trapezium ;

    long real procedure simpson ( long real procedure f
                                ; long real value     a, b
                                ; integer   value     n
                                ) ;
    begin
        long real h, sum1, sum2, x;
        integer   limit;
        h     := (b - a) / n;
        sum1  := 0;
        sum2  := 0;
        limit := n - 1;
        for i := 0 until limit do sum1 := sum1 + f(a + h * i + h / 2);
        for i := 1 until limit do sum2 := sum2 + f(a + h * i);
        h / 6 * (f(a) + f(b) + 4 * sum1 + 2 * sum2)
    end simpson ;

    % tests the above procedures                                             %
    procedure testIntegrators1 ( string(3) value     legend
                               ; long real procedure f
                               ; long real value     lowerLimit
                               ; long real value     upperLimit
                               ; integer   value     iterations
                               ) ;
        write( r_format := "A", r_w := 20, r_d := 6, s_w := 0,
             , legend
             , leftRect(  f, lowerLimit, upperLimit, iterations )
             , rightRect( f, lowerLimit, upperLimit, iterations )
             , midRect(   f, lowerLimit, upperLimit, iterations )
             , trapezium( f, lowerLimit, upperLimit, iterations )
             , simpson(   f, lowerLimit, upperLimit, iterations )
             );
    procedure testIntegrators2 ( string(3) value     legend
                               ; long real procedure f
                               ; long real value     lowerLimit
                               ; long real value     upperLimit
                               ; integer   value     iterations
                               ) ;
        write( r_format := "A", r_w := 16, r_d := 2, s_w := 0,
             , legend
             , leftRect(  f, lowerLimit, upperLimit, iterations ), "    "
             , rightRect( f, lowerLimit, upperLimit, iterations ), "    "
             , midRect(   f, lowerLimit, upperLimit, iterations ), "    "
             , trapezium( f, lowerLimit, upperLimit, iterations ), "    "
             , simpson(   f, lowerLimit, upperLimit, iterations ), "    "
             );

    begin % task test cases                                                  %
        long real procedure xCubed   ( long real value x ) ; x * x * x;
        long real procedure oneOverX ( long real value x ) ; 1 / x;
        long real procedure xValue   ( long real value x ) ; x;
        write( "   "
             , "           left rect"
             , "          right rect"
             , "            mid rect"
             , "           trapezium"
             , "             simpson"
            );
        testIntegrators1( "x^3", xCubed,   0,    1,     100 );
        testIntegrators1( "1/x", oneOverX, 1,  100,    1000 );
        testIntegrators2( "x  ", xValue,   0, 5000, 5000000 );
        testIntegrators2( "x  ", xValue,   0, 6000, 6000000 )
    end
end.
