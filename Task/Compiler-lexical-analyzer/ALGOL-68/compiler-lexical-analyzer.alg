BEGIN
  # implement C-like getchar, where EOF and EOLn are "characters" (-1 and 10 resp.). #
  INT eof = -1, eoln = 10;
  BOOL eof flag := FALSE;
  STRING buf := "";
  INT col := 1;
  INT line := 0;
  on logical file end (stand in, (REF FILE f)BOOL: eof flag := TRUE);
  PROC getchar = INT:
    IF   eof flag      THEN eof
    ELIF col = UPB buf THEN col +:= 1; eoln
    ELIF col > UPB buf THEN IF line > 0 THEN read(newline) FI;
                            line +:= 1;
                            read(buf);
                            IF eof flag THEN col := 1; eof
                            ELSE col := 0; getchar
                            FI
    ELSE col +:= 1; ABS buf[col]
    FI;
  PROC nextchar = INT: IF eof flag THEN eof ELIF col >= UPB buf THEN eoln ELSE ABS buf[col+1] FI;

  PROC is blank = (INT ch) BOOL: ch = 0 OR ch = 9 OR ch = 10 OR ch = 13 OR ch = ABS " ";
  PROC is digit = (INT ch) BOOL: ch >= ABS "0" AND ch <= ABS "9";
  PROC is ident start = (INT ch) BOOL: ch >= ABS "A" AND ch <= ABS "Z" OR
                                       ch >= ABS "a" AND ch <= ABS "z" OR
                                       ch = ABS "_";
  PROC is ident = (INT ch) BOOL: is ident start(ch) OR is digit(ch);

  PROC ident or keyword = (INT start char) VOID:
    BEGIN
      STRING w := REPR start char;
      INT start col = col;
      WHILE is ident (next char) DO w +:= REPR getchar OD;
      IF   w = "if"    THEN output2("Keyword_if", start col)
      ELIF w = "else"  THEN output2("Keyword_else", start col)
      ELIF w = "while" THEN output2("Keyword_while", start col)
      ELIF w = "print" THEN output2("Keyword_print", start col)
      ELIF w = "putc"  THEN output2("Keyword_putc", start col)
      ELSE output2("Identifier " + w, start col)
      FI
    END;
  PROC char = VOID:
    BEGIN
      INT start col = col;
      INT ch := getchar;
      IF   ch = ABS "'" THEN error("Empty character constant")
      ELIF ch = ABS "\" THEN ch := getchar;
                             IF   ch = ABS "n" THEN ch := 10
                             ELIF ch = ABS "\" THEN SKIP
                             ELSE error("Unknown escape sequence. \" + REPR ch)
                             FI
      FI;
      IF nextchar /= ABS "'" THEN error("Multi-character constant.") FI;
      getchar;
      output2("Integer " + whole(ch, 0), start col)
    END;
  PROC string = VOID:
    BEGIN
      INT start col = col;
      STRING s := """";
      WHILE INT ch := getchar; ch /= ABS """"
      DO
        IF   ch = eoln     THEN error("End-of-line while scanning string literal. Closing string character not found before end-of-line.")
        ELIF ch = eof      THEN error("End-of-file while scanning string literal. Closing string character not found.")
        ELIF ch = ABS "\"  THEN s +:= REPR ch; ch := getchar;
                                IF ch /= ABS "\" AND ch /= ABS "n" THEN error("Unknown escape sequence. \" + REPR ch) FI;
                                s +:= REPR ch
        ELSE s +:= REPR ch
        FI
      OD;
      output2("String " + s + """", start col)
    END;
  PROC comment = VOID:
    BEGIN
      WHILE INT ch := getchar; NOT (ch = ABS "*" AND nextchar = ABS "/")
      DO IF ch = eof THEN error("End-of-file in comment. Closing comment characters not found.") FI
      OD;
      getchar
    END;
  PROC number = (INT first digit) VOID:
    BEGIN
      INT start col = col;
      INT n := first digit - ABS "0";
      WHILE is digit (nextchar) DO
        INT u := getchar - ABS "0";
        IF LENG n * 10 + LENG u > max int THEN error("Integer too big") FI;
        n := n * 10 + u
      OD;
      IF is ident start (nextchar) THEN error("Invalid number. Starts like a number, but ends in non-numeric characters.") FI;
      output2("Integer " + whole(n, 0), start col)
    END;

  PROC output  = (STRING s) VOID: output2(s, col);
  PROC output2 = (STRING s, INT col) VOID: print((whole(line,-8), whole(col,-8), "  ", s, newline));

  PROC if follows = (CHAR second, STRING longer, shorter) VOID:
    IF nextchar = ABS second
    THEN output(longer); getchar
    ELSE output(shorter)
    FI;
  PROC error = (STRING s)VOID: (put(stand error, ("At ", whole(line,0), ":", whole(col,0), " ", s, new line)); stop);
  PROC unrecognized = (INT char) VOID: error("Unrecognized character " + REPR char);
  PROC double char = (INT first, STRING op) VOID:
    IF nextchar /= first THEN unrecognized(first)
    ELSE output2(op, col-1); getchar
    FI;

  WHILE INT ch := getchar; ch /= eof
  DO
    IF   is blank(ch) THEN SKIP
    ELIF ch = ABS "(" THEN output("LeftParen")
    ELIF ch = ABS ")" THEN output("RightParen")
    ELIF ch = ABS "{" THEN output("LeftBrace")
    ELIF ch = ABS "}" THEN output("RightBrace")
    ELIF ch = ABS ";" THEN output("Semicolon")
    ELIF ch = ABS "," THEN output("Comma")
    ELIF ch = ABS "*" THEN output("Op_multiply")
    ELIF ch = ABS "/" THEN IF next char = ABS "*" THEN comment
                           ELSE output("Op_divide")
                           FI
    ELIF ch = ABS "%" THEN output("Op_mod")
    ELIF ch = ABS "+" THEN output("Op_add")
    ELIF ch = ABS "-" THEN output("Op_subtract")
    ELIF ch = ABS "<" THEN if follows("=", "Op_lessequal", "Op_less")
    ELIF ch = ABS ">" THEN if follows("=", "Op_greaterequal", "Op_greater")
    ELIF ch = ABS "=" THEN if follows("=", "Op_equal", "Op_assign")
    ELIF ch = ABS "!" THEN if follows("=", "Op_notequal", "Op_not")
    ELIF ch = ABS "&" THEN double char(ch, "Op_and")
    ELIF ch = ABS "|" THEN double char(ch, "Op_or")
    ELIF is ident start (ch) THEN ident or keyword (ch)
    ELIF ch = ABS """" THEN string
    ELIF ch = ABS "'" THEN char
    ELIF is digit(ch) THEN number(ch)
    ELSE unrecognized(ch)
    FI
  OD;
  output("End_Of_Input")
END
