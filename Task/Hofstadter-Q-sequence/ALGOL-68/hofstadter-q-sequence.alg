BEGIN
        [100000]INT q;

        INT flips := 0;
        q[1] := q[2] := 1;
        FOR i FROM 3 TO UPB q DO
                q[i] := q[i - q[i - 1]] + q[i - q[i - 2]];
                IF q[i] < q[i - 1] THEN flips +:= 1 FI
        OD;

        FOR i TO 10 DO
                print((whole(q[i],0), IF i = 10 THEN newline ELSE space FI)) OD;

        print((whole(q[1000],0), newline));
        print(("flips: ", whole(flips,0), newline))
END
