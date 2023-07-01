begin
    comment Hailstone sequence - Algol 60;
    integer array collatz[1:400]; integer icollatz;

    integer procedure mod(i,j); value i,j; integer i,j;
    mod:=i-(i div j)*j;

    integer procedure hailstone(num);
    value num; integer num;
    begin
        integer i,n;
        icollatz:=1; n:=num; i:=0;
        collatz[icollatz]:=n;
        for i:=i+1 while n notequal 1 do begin
            if mod(n,2)=0 then n:=n div 2
                          else n:=(3*n)+1;
            icollatz:=icollatz+1;
            collatz[icollatz]:=n
        end;
        hailstone:=icollatz
    end hailstone;

    integer i,nn,ncollatz,count,nlongest,nel,nelcur,nnn;
    nn:=27;
    ncollatz:=hailstone(nn);
    outstring(1,"sequence for"); outinteger(1,nn); outstring(1," :\n");
    for i:=1 step 1 until ncollatz do outinteger(1,collatz[i]);
    outstring(1,"\n");
    outstring(1,"number of elements:"); outinteger(1,ncollatz);
    outstring(1,"\n\n");
    nlongest:=0; nel:=0; nnn:=100000;
    for count:=1, count+1 while count<nnn do begin
        nelcur:=hailstone(count);
        if nelcur>nel then begin
            nel:=nelcur;
            nlongest:=count
        end
    end;
    outstring(1,"number <"); outinteger(1,nnn);
    outstring(1,"with the longest sequence:"); outinteger(1,nlongest);
    outstring(1,", with"); outinteger(1,nel); outstring(1,"elements.");
    outstring(1,"\n")
end
