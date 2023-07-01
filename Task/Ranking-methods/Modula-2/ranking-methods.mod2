MODULE RankingMethods;
FROM FormatString IMPORT FormatString;
FROM RealStr IMPORT RealToFixed;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteCard(c : CARDINAL);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%c", buf, c);
    WriteString(buf)
END WriteCard;

TYPE Entry = RECORD
    name : ARRAY[0..15] OF CHAR;
    score : CARDINAL;
END;

PROCEDURE OrdinalRanking(CONST entries : ARRAY OF Entry);
VAR
    buf : ARRAY[0..31] OF CHAR;
    i : CARDINAL;
BEGIN
    WriteString("Ordinal Ranking");
    WriteLn;
    WriteString("---------------");
    WriteLn;

    FOR i:=0 TO HIGH(entries) DO
        FormatString("%c\t%c\t%s\n", buf, i + 1, entries[i].score, entries[i].name);
        WriteString(buf)
    END;

    WriteLn
END OrdinalRanking;

PROCEDURE StandardRanking(CONST entries : ARRAY OF Entry);
VAR
    buf : ARRAY[0..31] OF CHAR;
    i,j : CARDINAL;
BEGIN
    WriteString("Standard Ranking");
    WriteLn;
    WriteString("---------------");
    WriteLn;

    j := 1;
    FOR i:=0 TO HIGH(entries) DO
        FormatString("%c\t%c\t%s\n", buf, j, entries[i].score, entries[i].name);
        WriteString(buf);
        IF entries[i+1].score < entries[i].score THEN
            j := i + 2
        END
    END;

    WriteLn
END StandardRanking;

PROCEDURE DenseRanking(CONST entries : ARRAY OF Entry);
VAR
    buf : ARRAY[0..31] OF CHAR;
    i,j : CARDINAL;
BEGIN
    WriteString("Dense Ranking");
    WriteLn;
    WriteString("---------------");
    WriteLn;

    j := 1;
    FOR i:=0 TO HIGH(entries) DO
        FormatString("%c\t%c\t%s\n", buf, j, entries[i].score, entries[i].name);
        WriteString(buf);
        IF entries[i+1].score < entries[i].score THEN
            INC(j)
        END
    END;

    WriteLn
END DenseRanking;

PROCEDURE ModifiedRanking(CONST entries : ARRAY OF Entry);
VAR
    buf : ARRAY[0..31] OF CHAR;
    i,j,count : CARDINAL;
BEGIN
    WriteString("Modified Ranking");
    WriteLn;
    WriteString("---------------");
    WriteLn;

    i := 0;
    j := 1;
    WHILE i < HIGH(entries) DO
        IF entries[i].score # entries[i+1].score THEN
            FormatString("%c\t%c\t%s\n", buf, i+1, entries[i].score, entries[i].name);
            WriteString(buf);

            count := 1;
            FOR j:=i+1 TO HIGH(entries)-1 DO
                IF entries[j].score # entries[j+1].score THEN
                    BREAK
                END;
                INC(count)
            END;

            j := 0;
            WHILE j < count-1 DO
                FormatString("%c\t%c\t%s\n", buf, i+count+1, entries[i+j+1].score, entries[i+j+1].name);
                WriteString(buf);
                INC(j)
            END;
            i := i + count - 1
        END;
        INC(i)
    END;

    FormatString("%c\t%c\t%s\n\n", buf, HIGH(entries)+1, entries[HIGH(entries)].score, entries[HIGH(entries)].name);
    WriteString(buf)
END ModifiedRanking;

PROCEDURE FractionalRanking(CONST entries : ARRAY OF Entry);
VAR
    buf : ARRAY[0..32] OF CHAR;
    i,j,count : CARDINAL;
    sum : REAL;
BEGIN
    WriteString("Fractional Ranking");
    WriteLn;
    WriteString("---------------");
    WriteLn;

    sum := 0.0;
    i := 0;
    WHILE i <= HIGH(entries) DO
        IF (i = HIGH(entries) - 1) OR (entries[i].score # entries[i+1].score) THEN
            RealToFixed(FLOAT(i+1),1,buf);
            WriteString(buf);
            FormatString("\t%c\t%s\n", buf, entries[i].score, entries[i].name);
            WriteString(buf)
        ELSE
            sum := FLOAT(i);
            count := 1;

            j := i;
            WHILE entries[j].score = entries[j+1].score DO
                sum := sum + FLOAT(j + 1);
                INC(count);
                INC(j)
            END;
            FOR j:=0 TO count-1 DO
                RealToFixed(sum/FLOAT(count)+1.0,1,buf);
                WriteString(buf);
                FormatString("\t%c\t%s\n", buf, entries[i+j].score, entries[i+j].name);
                WriteString(buf)
            END;
            i := i + count - 1
        END;
        INC(i)
    END
END FractionalRanking;

(* Main *)
TYPE EA = ARRAY[0..6] OF Entry;
VAR entries : EA;
BEGIN
    entries := EA{
        {"Solomon", 44},
        {"Jason", 42},
        {"Errol", 42},
        {"Garry", 41},
        {"Bernard", 41},
        {"Barry", 41},
        {"Stephen", 39}
    };

    OrdinalRanking(entries);
    StandardRanking(entries);
    DenseRanking(entries);
    ModifiedRanking(entries);
    FractionalRanking(entries);

    ReadChar
END RankingMethods.
