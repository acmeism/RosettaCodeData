begin
    comment Greatest common divisor - algol 60;
	
    integer procedure gcd(m,n);
 	value m,n;
	integer m,n;
    begin
        integer a,b;
        a:=abs(m);
        b:=abs(n);
        if a=0 then gcd:=b
        else begin
			integer c,i;
		    for i:=a while b notequal 0 do begin
                c:=b;
                b:=a-(a div b)*b;
                a:=c
            end;
            gcd:=a
        end
    end gcd;
	
    outinteger(1,gcd(21,35))
end
