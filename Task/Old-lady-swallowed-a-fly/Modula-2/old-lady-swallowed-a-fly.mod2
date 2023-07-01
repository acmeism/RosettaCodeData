MODULE OldLady;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE
    AA = ARRAY[0..7] OF ARRAY[0..7] OF CHAR;
    VA = ARRAY[0..7] OF ARRAY[0..63] OF CHAR;
VAR
    buf : ARRAY[0..127] OF CHAR;
    animals : AA;
    verses : VA;
    i,j : INTEGER;
BEGIN
    FormatString("I don't know why she swallowed that fly.\nPerhaps she'll die\n", buf);

    animals := AA{"fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse"};
    verses := VA{
        "I don't know why she swallowed that fly.",
        "That wiggled and jiggled and tickled inside her",
        "How absurd, to swallow a bird",
        "Imagine that. She swallowed a cat",
        "What a hog to swallow a dog",
        "She just opened her throat and swallowed that goat",
        "I don't know how she swallowed that cow",
        "She's dead of course"
    };

    FOR i:=0 TO 7 DO
        FormatString("There was an old lady who swallowed a %s\n%s\n", buf, animals[i], verses[i]);
        WriteString(buf);
        IF i=0 THEN
            WriteString("Perhaps she'll die");
            WriteLn;
            WriteLn;
        END;
        j := i;
        WHILE (j>0) AND (i<7) DO
            FormatString("She swallowed the %s to catch the %s\n", buf, animals[j], animals[j-1]);
            WriteString(buf);
            IF j=1 THEN
                WriteString(verses[0]);
                WriteLn;
                WriteString("Perhaps she'll die");
                WriteLn;
                WriteLn
            END;
            DEC(j)
        END;
    END;

    ReadChar
END OldLady.
