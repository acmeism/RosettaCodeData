MODULE Towers;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

PROCEDURE Move(n,from,to,via : INTEGER);
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    IF n>0 THEN
        Move(n-1, from, via, to);
        FormatString("Move disk %i from pole %i to pole %i\n", buf, n, from, to);
        WriteString(buf);
        Move(n-1, via, to, from)
    END
END Move;

BEGIN
    Move(3, 1, 3, 2);

    ReadChar
END Towers.
