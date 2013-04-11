main: (
    [10][10]INT a; INT i, j;

    FOR i FROM LWB a TO UPB a DO
        FOR j FROM LWB a[i] TO UPB a[i] DO
            a[i][j] := ENTIER (random * 20 + 1)
        OD
    OD ;
    FOR i FROM LWB a TO UPB a DO
        FOR j FROM LWB a[i] TO UPB a[i] DO
            print(whole(a[i][j], -3));
            IF a[i][j] = 20 THEN
                GO TO xkcd com 292 # http://xkcd.com/292/ #
            FI
        OD;
        print(new line)
    OD;
xkcd com 292:
    print(new line)
)
