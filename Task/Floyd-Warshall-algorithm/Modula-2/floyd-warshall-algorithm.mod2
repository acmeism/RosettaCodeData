MODULE FloydWarshall;
FROM FormatString IMPORT FormatString;
FROM SpecialReals IMPORT Infinity;
FROM Terminal IMPORT ReadChar,WriteString,WriteLn;

CONST NUM_VERTICIES = 4;
TYPE
    IntArray = ARRAY[0..NUM_VERTICIES-1],[0..NUM_VERTICIES-1] OF INTEGER;
    RealArray = ARRAY[0..NUM_VERTICIES-1],[0..NUM_VERTICIES-1] OF REAL;

PROCEDURE FloydWarshall(weights : ARRAY OF ARRAY OF INTEGER);
VAR
    dist : RealArray;
    next : IntArray;
    i,j,k : INTEGER;
BEGIN
    FOR i:=0 TO NUM_VERTICIES-1 DO
        FOR j:=0 TO NUM_VERTICIES-1 DO
            dist[i,j] := Infinity;
        END
    END;
    k := HIGH(weights);
    FOR i:=0 TO k DO
        dist[weights[i,0]-1,weights[i,1]-1] := FLOAT(weights[i,2]);
    END;
    FOR i:=0 TO NUM_VERTICIES-1 DO
        FOR j:=0 TO NUM_VERTICIES-1 DO
            IF i#j THEN
                next[i,j] := j+1;
            END
        END
    END;
    FOR k:=0 TO NUM_VERTICIES-1 DO
        FOR i:=0 TO NUM_VERTICIES-1 DO
            FOR j:=0 TO NUM_VERTICIES-1 DO
                IF dist[i,j] > dist[i,k] + dist[k,j] THEN
                    dist[i,j] := dist[i,k] + dist[k,j];
                    next[i,j] := next[i,k];
                END
            END
        END
    END;
    PrintResult(dist, next);
END FloydWarshall;

PROCEDURE PrintResult(dist : RealArray; next : IntArray);
VAR
    i,j,u,v : INTEGER;
    buf : ARRAY[0..63] OF CHAR;
BEGIN
    WriteString("pair     dist    path");
    WriteLn;
    FOR i:=0 TO NUM_VERTICIES-1 DO
        FOR j:=0 TO NUM_VERTICIES-1 DO
            IF i#j THEN
                u := i + 1;
                v := j + 1;
                FormatString("%i -> %i    %2i     %i", buf, u, v, TRUNC(dist[i,j]), u);
                WriteString(buf);
                REPEAT
                    u := next[u-1,v-1];
                    FormatString(" -> %i", buf, u);
                    WriteString(buf);
                UNTIL u=v;
                WriteLn
            END
        END
    END
END PrintResult;

TYPE WeightArray = ARRAY[0..4],[0..2] OF INTEGER;
VAR weights : WeightArray;
BEGIN
    weights := WeightArray{
        {1,  3, -2},
        {2,  1,  4},
        {2,  3,  3},
        {3,  4,  2},
        {4,  2, -1}
    };

    FloydWarshall(weights);

    ReadChar
END FloydWarshall.
