begin comment find some Disarium numbers
                 - numbers whose digit position-power sums are equal to the
                   number, e.g. 135 = 1^1 + 3^2 + 5^3;
    integer array power [ 1 : 9, 0 : 9 ];
    integer count, powerOfTen, length, n, d;
    comment compute the nth powers of 0-9;
    for d := 0 step 1 until 9 do power[ 1, d ] := d;
    for n := 2 step 1 until 9 do begin
        power[ n, 0 ] := 0;
        for d := 1 step 1 until 9 do power[ n, d ] := power[ n - 1, d ] * d
    end n;
    comment print the first few Disarium numbers;
    count      :=  0;
    powerOfTen := 10;
    length     :=  1;
    n          := -1;
    for n := n + 1 while count < 19 do begin
        integer v, dps, p;
        if n = powerOfTen then begin
            comment the number of digfits just increased;
            powerOfTen := powerOfTen * 10;
            length     := length     +  1
        end;
        comment form the digit power sum;
        v   := n;
        dps := 0;
        for p := length step -1 until 1 do begin
            dps := dps + power[ p, v - ( ( v % 10 ) * 10 ) ];
            v   := v % 10
        end p;
        if dps = n then begin
            comment n is Disarium;
            count := count + 1;
            outinteger( 1, n )
        end
    end n
end
