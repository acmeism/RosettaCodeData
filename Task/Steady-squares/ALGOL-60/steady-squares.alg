begin comment find steady squares - numbers whose square ends in the number
              e.g.: 376^2 = 141 376 ;

    integer powerOfTen, p;
    powerOfTen := 10;

    comment note the final digit must be 1, 5 or 6 ;
    for p := 0 step 10 until 10 000 do begin
        integer d;
        if p = powerOfTen then begin
            comment number of digits has increased ;
            powerOfTen := powerOfTen * 10
        end;
        for d := 1, 5, 6 do begin
            integer m, n, n2;
            n  := p + d;
            n2 := n * n;
            m  := n2 - ( ( n2 % powerOfTen ) * powerOfTen ) ;
            if m = n then outinteger( 1, n )
        end
    end
end
