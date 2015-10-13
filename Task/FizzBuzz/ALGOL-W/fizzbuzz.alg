begin
    i_w := 1; % set integers to print in minimum space %
    for i := 1 until 100 do begin
        if      i rem 15 = 0 then write( "FizzBuzz" )
        else if i rem  5 = 0 then write( "Buzz" )
        else if i rem  3 = 0 then write( "Fizz" )
        else                      write( i )
    end for_i
end.
