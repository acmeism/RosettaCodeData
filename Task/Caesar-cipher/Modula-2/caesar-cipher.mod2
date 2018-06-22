MODULE CaesarCipher;
FROM Conversions IMPORT IntToStr;
FROM Terminal IMPORT WriteString, WriteLn, ReadChar;

TYPE String = ARRAY[0..64] OF CHAR;

PROCEDURE Encrypt(p : String; key : CARDINAL) : String;
VAR e : String;
VAR i,t : CARDINAL;
VAR c : CHAR;
BEGIN
    FOR i:=0 TO HIGH(p) DO
        IF p[i]=0C THEN BREAK; END;

        t := ORD(p[i]);
        IF (p[i]>='A') AND (p[i]<='Z') THEN
            t := t + key;
            IF t>ORD('Z') THEN
                t := t - 26;
            END;
        ELSIF (p[i]>='a') AND (p[i]<='z') THEN
            t := t + key;
            IF t>ORD('z') THEN
                t := t - 26;
            END;
        END;
        e[i] := CHR(t);
    END;
    RETURN e;
END Encrypt;

PROCEDURE Decrypt(p : String; key : CARDINAL) : String;
VAR e : String;
VAR i,t : CARDINAL;
VAR c : CHAR;
BEGIN
    FOR i:=0 TO HIGH(p) DO
        IF p[i]=0C THEN BREAK; END;

        t := ORD(p[i]);
        IF (p[i]>='A') AND (p[i]<='Z') THEN
            t := t - key;
            IF t<ORD('A') THEN
                t := t + 26;
            END;
        ELSIF (p[i]>='a') AND (p[i]<='z') THEN
            t := t - key;
            IF t<ORD('a') THEN
                t := t + 26;
            END;
        END;
        e[i] := CHR(t);
    END;
    RETURN e;
END Decrypt;

VAR txt,enc : String;
VAR key : CARDINAL;
BEGIN
    txt := "The five boxing wizards jump quickly";
    key := 3;

    WriteString("Original:  ");
    WriteString(txt);
    WriteLn;

    enc := Encrypt(txt, key);
    WriteString("Encrypted: ");
    WriteString(enc);
    WriteLn;

    WriteString("Decrypted: ");
    WriteString(Decrypt(enc, key));
    WriteLn;

    ReadChar;
END CaesarCipher.
