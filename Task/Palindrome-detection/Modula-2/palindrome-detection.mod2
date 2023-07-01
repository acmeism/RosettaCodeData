MODULE Palindrome;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

PROCEDURE IsPalindrome(str : ARRAY OF CHAR) : BOOLEAN;
VAR i,m : INTEGER;
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    i := 0;
    m := HIGH(str) - 1;
    WHILE i<m DO
        IF str[i] # str[m-i] THEN
            RETURN FALSE
        END;
        INC(i)
    END;
    RETURN TRUE
END IsPalindrome;

PROCEDURE Print(str : ARRAY OF CHAR);
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    FormatString("%s: %b\n", buf, str, IsPalindrome(str));
    WriteString(buf)
END Print;

BEGIN
    Print("");
    Print("z");
    Print("aha");
    Print("sees");
    Print("oofoe");
    Print("deified");
    Print("Deified");
    Print("amanaplanacanalpanama");
    Print("ingirumimusnocteetconsumimurigni");

    ReadChar
END Palindrome.
