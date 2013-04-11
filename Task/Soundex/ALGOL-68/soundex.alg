    PROC soundex = (STRING s) STRING:
    BEGIN
        PROC encode = (CHAR c) CHAR:
        BEGIN
            # We assume the alphabet is contiguous. #
            "-123-12*-22455-12623-1*2-2"[ABS to lower(c) - ABS "a" + 1]
        END;
        INT soundex code length = 4;
        STRING result := soundex code length * "0";
        IF s /= "" THEN
            CHAR previous;
            INT  j;
            result[j := 1] := s[1];
            previous := encode(s[1]);
            FOR i FROM 2 TO UPB s WHILE j < soundex code length
            DO
                IF is alpha(s[i]) THEN
                    CHAR code = encode(s[i]);
                    IF is digit(code) AND code /= previous THEN
                        result[j +:= 1] := code;
                        previous := code
                    ELIF code = "-" THEN
                        # Only vowels (y counts here) hide the last-added character #
                        previous := code
                    FI
                FI
            OD
        FI;
        result
    END;

    # Test code to persuade one that it does work. #

    MODE TEST = STRUCT (STRING input, STRING expected output);

    [] TEST soundex test = (
        ("Soundex",    "S532"), ("Example",     "E251"),
        ("Sownteks",   "S532"), ("Ekzampul",    "E251"),
        ("Euler",      "E460"), ("Gauss",       "G200"),
        ("Hilbert",    "H416"), ("Knuth",       "K530"),
        ("Lloyd",      "L300"), ("Lukasiewicz", "L222"),
        ("Ellery",     "E460"), ("Ghosh",       "G200"),
        ("Heilbronn",  "H416"), ("Kant",        "K530"),
        ("Ladd",       "L300"), ("Lissajous",   "L222"),
        ("Wheaton",    "W350"), ("Burroughs",   "B620"),
        ("Burrows",    "B620"), ("O'Hara",      "O600"),
        ("Washington", "W252"), ("Lee",         "L000"),
        ("Gutierrez",  "G362"), ("Pfister",     "P236"),
        ("Jackson",    "J250"), ("Tymczak",     "T522"),
        ("VanDeusen",  "V532"), ("Ashcraft",    "A261")
    );

    #
      Apologies for the magic number in the padding of the input
      and the wired-in heading.
    #

    print(("Test name   Code Got", newline, "----------------------", newline));
    FOR i FROM LWB soundex test TO UPB soundex test
    DO
        STRING output = soundex(input OF soundex test[i]);
        printf(($g, n (12 - UPB input OF soundex test[i]) x$, input OF soundex test[i]));
        printf(($g, 1x, g, 1x$, expected output OF soundex test[i], output));
        printf(($b("ok", "not ok"), 1l$, output = expected output OF soundex test[i]))
    OD
