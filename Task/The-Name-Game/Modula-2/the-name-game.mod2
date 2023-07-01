MODULE NameGame;
FROM Strings IMPORT Concat;
FROM ExStrings IMPORT Lowercase;
FROM Terminal IMPORT WriteString, WriteLn, ReadChar;

PROCEDURE PrintVerse(name : ARRAY OF CHAR);
TYPE String = ARRAY[0..64] OF CHAR;
VAR y,b,f,m : String;
BEGIN
    Lowercase(name);

    CASE name[0] OF
        'a','e','i','o','u' : y := name;
    ELSE
        y := name[1..LENGTH(name)];
    END;

    Concat("b", y, b);
    Concat("f", y, f);
    Concat("m", y, m);

    CASE name[0] OF
        'b' : b := y; |
        'f' : f := y; |
        'm' : m := y;
    ELSE
    END;

    name[0] := CAP(name[0]);

    (* Line 1 *)
    WriteString(name);
    WriteString(", ");
    WriteString(name);
    WriteString(", bo-");
    WriteString(b);
    WriteLn;

    (* Line 2 *)
    WriteString("Banana-fana fo-");
    WriteString(f);
    WriteLn;

    (* Line 3 *)
    WriteString("Fee-fi-mo-");
    WriteString(m);
    WriteLn;

    (* Line 4 *)
    WriteString(name);
    WriteString("!");
    WriteLn;

    WriteLn;
END PrintVerse;

BEGIN
    PrintVerse("Gary");
    PrintVerse("Earl");
    PrintVerse("Billy");
    PrintVerse("Felix");
    PrintVerse("Mary");
    PrintVerse("Steve");

    ReadChar;
END NameGame.
