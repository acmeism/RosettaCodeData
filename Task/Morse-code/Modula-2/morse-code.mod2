MODULE MorseCode;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteMorseCode(str : ARRAY OF CHAR);
VAR i : CARDINAL;
BEGIN
    WriteString(str);
    WriteLn;
    FOR i:=0 TO HIGH(str) DO
        CASE CAP(str[i]) OF
              'A': WriteString(".-");
            | 'B': WriteString("-...");
            | 'C': WriteString("-.-");
            | 'D': WriteString("-..");
            | 'E': WriteString(".");
            | 'F': WriteString("..-.");
            | 'G': WriteString("--.");
            | 'H': WriteString("....");
            | 'I': WriteString("..");
            | 'J': WriteString(".---");
            | 'K': WriteString("-.-");
            | 'L': WriteString(".-..");
            | 'M': WriteString("--");
            | 'N': WriteString("-.");
            | 'O': WriteString("---");
            | 'P': WriteString(".--.");
            | 'Q': WriteString("--.-");
            | 'R': WriteString(".-.");
            | 'S': WriteString("...");
            | 'T': WriteString("-");
            | 'U': WriteString("..-");
            | 'V': WriteString("...-");
            | 'W': WriteString(".--");
            | 'X': WriteString("-..-");
            | 'Y': WriteString("-.--");
            | 'Z': WriteString("--..");
            | '0': WriteString("-----");
            | '1': WriteString(".----");
            | '2': WriteString("..---");
            | '3': WriteString("...--");
            | '4': WriteString("....-");
            | '5': WriteString(".....");
            | '6': WriteString("-....");
            | '7': WriteString("--...");
            | '8': WriteString("---..");
            | '9': WriteString("----.");
            | ' ': WriteString("  ");
        ELSE
            IF (str[i] # 0C) THEN
                WriteString("?");
            END
        END;
        WriteString(" ");
    END;
END WriteMorseCode;

BEGIN
    WriteMorseCode("hello world");
    WriteLn;

    ReadChar;
END MorseCode.
