MODULE SubsetSum;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE
    String = ARRAY[0..63] OF CHAR;
    Item = RECORD
        word : String;
        weight : INTEGER;
    END;

PROCEDURE WriteItem(self : Item);
VAR buf : String;
BEGIN
    FormatString("(%s, %i)", buf, self.word, self.weight);
    WriteString(buf);
END WriteItem;

CONST N = 31;
VAR
    items : ARRAY[0..N] OF Item;
    indicies : ARRAY[0..N] OF INTEGER;
    count : INTEGER;
PROCEDURE Init;
VAR i : INTEGER;
BEGIN
    items[0] := Item{"alliance", -624};
    items[1] := Item{"archbishop", -915};
    items[2] := Item{"balm", 397};
    items[3] := Item{"bonnet", 452};
    items[4] := Item{"brute", 870};
    items[5] := Item{"centipede", -658};
    items[6] := Item{"cobol", 362};
    items[7] := Item{"covariate", 590};
    items[8] := Item{"departure", 952};
    items[9] := Item{"deploy", 44};
    items[10] := Item{"diophantine", 645};
    items[11] := Item{"efferent", 54};
    items[12] := Item{"elysee", -326};
    items[13] := Item{"eradicate", 376};
    items[14] := Item{"escritoire", 856};
    items[15] := Item{"exorcism", -983};
    items[16] := Item{"fiat", 170};
    items[17] := Item{"filmy", -874};
    items[18] := Item{"flatworm", 503};
    items[19] := Item{"gestapo", 915};
    items[20] := Item{"infra", -847};
    items[21] := Item{"isis", -982};
    items[22] := Item{"lindholm", 999};
    items[23] := Item{"markham", 475};
    items[24] := Item{"mincemeat", -880};
    items[25] := Item{"moresby", 756};
    items[26] := Item{"mycenae", 183};
    items[27] := Item{"plugging", -266};
    items[28] := Item{"smokescreen", 423};
    items[29] := Item{"speakeasy", -745};
    items[30] := Item{"vein", 813};

    count := 0;
END Init;

CONST LIMIT = 5;
PROCEDURE ZeroSum(i,w : INTEGER);
VAR j,k : INTEGER;
BEGIN
    IF (i#0) AND (w=0) THEN
        FOR j:=0 TO i-1 DO
            WriteItem(items[indicies[j]]);
            WriteString(" ");
        END;
        WriteLn;
        WriteString("---------------");
        WriteLn;
        IF count<LIMIT THEN
            INC(count)
        ELSE
            RETURN;
        END;
    END;
    IF i#0 THEN
        k := indicies[i-1]+1;
    ELSE
        k := 0;
    END;
    FOR j:=k TO N-1 DO
        indicies[i] := j;
        ZeroSum(i+1,w+items[j].weight);
        IF count=LIMIT THEN RETURN; END;
    END;
END ZeroSum;

VAR buf : ARRAY[0..63] OF CHAR;
VAR d : INTEGER;
BEGIN
    Init;
    d := LIMIT;
    FormatString("The weights of the following %i subsets add up to zero:\n\n", buf, d);
    WriteString(buf);
    ZeroSum(0,0);

    ReadChar;
END SubsetSum.
