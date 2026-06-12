MODULE LCP;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE String = ARRAY[0..15] OF CHAR;

PROCEDURE Length(str : String) : CARDINAL;
VAR len : CARDINAL;
BEGIN
    len := 0;
    WHILE str[len] # 0C DO
        INC(len)
    END;
    RETURN len
END Length;

PROCEDURE LongestCommonPrefix(params : ARRAY OF String) : String;
VAR
    ret : String;
    idx,widx : CARDINAL;
    thisLetter : CHAR;
BEGIN
    ret := "";
    idx := 0;
    LOOP
        thisLetter := 0C;
        FOR widx:=0 TO HIGH(params) DO
            IF idx = Length(params[widx]) THEN
                (* if we reached the end of a word then we are done *)
                RETURN ret
            END;
            IF thisLetter = 0C THEN
                (* if this is the first word then note the letter we are looking for *)
                thisLetter := params[widx][idx]
            END;
            IF thisLetter # params[widx][idx] THEN
                RETURN ret
            END
        END;

        (* if we haven't said we are done then this position passed *)
        ret[idx] := thisLetter;
        INC(idx);
        ret[idx] := 0C
    END;
    RETURN ret
END LongestCommonPrefix;

(* Main *)
TYPE
    AS3 = ARRAY[0..2] OF String;
    AS2 = ARRAY[0..1] OF String;
    AS1 = ARRAY[0..0] OF String;
BEGIN
    WriteString(LongestCommonPrefix(AS3{"interspecies", "interstellar", "interstate"}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS2{"throne", "throne"}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS2{"throne", "dungeon"}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS3{"throne", "", "throne"}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS1{"cheese"}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS1{""}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS2{"prefix", "suffix"}));
    WriteLn;
    WriteString(LongestCommonPrefix(AS2{"foo", "foobar"}));
    WriteLn;

    ReadChar
END LCP.
