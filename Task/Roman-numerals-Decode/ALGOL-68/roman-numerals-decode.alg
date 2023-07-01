    PROC roman to int = (STRING roman) INT:
    BEGIN
        PROC roman digit value = (CHAR roman digit) INT:
            (roman digit = "M" | 1000 |:
             roman digit = "D" |  500 |:
             roman digit = "C" |  100 |:
             roman digit = "L" |   50 |:
             roman digit = "X" |   10 |:
             roman digit = "V" |    5 |:
             roman digit = "I" |    1);

        INT result := 0, previous value := 0, run := 0;

        FOR i FROM LWB roman TO UPB roman
        DO
            INT value = roman digit value(roman[i]);
            IF previous value = value THEN
                run +:= value
            ELSE
                IF previous value < value THEN
                    result -:= run
                ELSE
                    result +:= run
                FI;
                run := previous value := value
            FI
        OD;

        result +:= run
    END;

    MODE TEST = STRUCT (STRING input, INT expected output);

    [] TEST roman test = (
        ("MMXI",    2011), ("MIM",     1999),
        ("MCMLVI",  1956), ("MDCLXVI", 1666),
        ("XXCIII",    83), ("LXXIIX",    78),
        ("IIIIX",      6)
    );

    print(("Test input  Value   Got", newline, "--------------------------", newline));
    FOR i FROM LWB roman test TO UPB roman test
    DO
        INT output = roman to int(input OF roman test[i]);
        printf(($g, n (12 - UPB input OF roman test[i]) x$, input OF roman test[i]));
        printf(($g(5), 1x, g(5), 1x$, expected output OF roman test[i], output));
        printf(($b("ok", "not ok"), 1l$, output = expected output OF roman test[i]))
    OD
