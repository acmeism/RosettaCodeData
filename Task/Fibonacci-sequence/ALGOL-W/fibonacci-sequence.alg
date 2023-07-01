begin
    % return the nth Fibonacci number %
    integer procedure Fibonacci( integer value n ) ;
        begin
            integer fn, fn1, fn2;
            fn2 := 1;
            fn1 := 0;
            fn  := 0;
            for i := 1 until n do begin
                fn  := fn1 + fn2;
                fn2 := fn1;
                fn1 := fn
            end ;
            fn
        end Fibonacci ;

    for i := 0 until 10 do writeon( i_w := 3, s_w := 0, Fibonacci( i ) )

end.
