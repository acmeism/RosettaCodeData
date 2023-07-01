begin
    comment Fibonacci sequence;
    integer procedure fibonacci(n); value n; integer n;
    begin
        integer i, fn, fn1, fn2;
        fn2 := 1;
        fn1 := 0;
        fn  := 0;
        for i := 1 step 1 until n do begin
            fn  := fn1 + fn2;
            fn2 := fn1;
            fn1 := fn
        end;
        fibonacci := fn
    end fibonacci;

    integer i;
    for i := 0 step 1 until 20 do outinteger(1,fibonacci(i))
end
