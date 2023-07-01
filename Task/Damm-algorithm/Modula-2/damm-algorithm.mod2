MODULE DammAlgorithm;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE TA = ARRAY[0..9],[0..9] OF INTEGER;
CONST table = TA{
        {0, 3, 1, 7, 5, 9, 8, 6, 4, 2},
        {7, 0, 9, 2, 1, 5, 4, 8, 6, 3},
        {4, 2, 0, 6, 8, 7, 1, 3, 5, 9},
        {1, 7, 5, 0, 9, 8, 3, 4, 2, 6},
        {6, 1, 2, 3, 0, 4, 5, 9, 7, 8},
        {3, 6, 7, 4, 2, 0, 9, 5, 8, 1},
        {5, 8, 6, 9, 7, 2, 0, 1, 3, 4},
        {8, 9, 4, 5, 3, 6, 2, 0, 1, 7},
        {9, 4, 3, 8, 6, 1, 7, 2, 0, 5},
        {2, 5, 8, 1, 4, 3, 6, 7, 9, 0}
    };

PROCEDURE Damm(s : ARRAY OF CHAR) : BOOLEAN;
VAR interim,i : INTEGER;
BEGIN
    interim := 0;

    i := 0;
    WHILE s[i] # 0C DO
        interim := table[interim,INT(s[i])-INT('0')];
        INC(i);
    END;
    RETURN interim=0;
END Damm;

PROCEDURE Print(number : INTEGER);
VAR
    isValid : BOOLEAN;
    buf : ARRAY[0..16] OF CHAR;
BEGIN
    FormatString("%i", buf, number);
    isValid := Damm(buf);
    WriteString(buf);
    IF isValid THEN
        WriteString(" is valid");
    ELSE
        WriteString(" is invalid");
    END;
    WriteLn;
END Print;

BEGIN
    Print(5724);
    Print(5727);
    Print(112946);
    Print(112949);

    ReadChar;
END DammAlgorithm.
