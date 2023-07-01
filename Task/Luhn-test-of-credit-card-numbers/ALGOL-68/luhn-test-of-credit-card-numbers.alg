PROC to int = (CHAR c)INT:
    ABS c - ABS "0";

PROC confirm = (STRING id)BOOL:
(
    BOOL is odd digit := TRUE;
    INT s := 0;
    STRING cp;

    FOR cp key FROM UPB id BY -1 TO LWB id DO
        INT k := to int(id[cp key]);
        s +:=
            IF is odd digit THEN k
            ELIF k /= 9 THEN 2*k MOD 9
            ELSE 9
            FI;
        is odd digit := NOT is odd digit
    OD;
    0 = s MOD 10
);

main:
(
    []STRING t cases = (
        "49927398716",
        "49927398717",
        "1234567812345678",
        "1234567812345670"
    );
    FOR cp key TO UPB t cases DO
        STRING cp = t cases[cp key];
        print((cp, ": ", confirm(cp), new line))
    OD
)
