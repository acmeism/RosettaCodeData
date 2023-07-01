INT empty=0;

PROC spiral = (INT n)[,]INT: (
    INT dx:=1, dy:=0;            # Starting increments #
    INT x:=0, y:=0;              # Starting location #
    [0:n-1,0:n-1]INT my array;
    FOR y FROM LWB my array TO UPB my array DO
        FOR x FROM LWB my array TO UPB my array DO
            my array[x,y]:=empty
        OD
    OD;
    FOR i TO n**2 DO
        my array[x,y] := i;
        INT nx:=x+dx, ny:=y+dy;
        IF ( 0<=nx AND nx<n AND 0<=ny AND ny<n | my array[nx,ny] = empty | FALSE ) THEN
            x:=nx; y:=ny
        ELSE
            INT swap:=dx; dx:=-dy; dy:=swap;
            x+:=dx; y+:=dy
        FI
    OD;
    my array
);

PROC print spiral = ([,]INT my array)VOID:(
    FOR y FROM LWB my array TO UPB my array DO
        FOR x FROM LWB my array TO UPB my array DO
            print(whole(my array[x,y],-3))
        OD;
        print(new line)
    OD
);

print spiral(spiral(5))
