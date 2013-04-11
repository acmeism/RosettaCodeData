CONST matchtext = "Goodbye London!"
CONST repltext  = "Hello New York!"
CONST matchlen  = LEN(matchtext)

DIM L0 AS INTEGER, x AS INTEGER, filespec AS STRING, linein AS STRING

L0 = 1
WHILE LEN(COMMAND$(L0))
    filespec = DIR$(COMMAND$(L0))
    WHILE LEN(filespec)
        OPEN filespec FOR BINARY AS 1
            linein = SPACE$(LOF(1))
            GET #1, 1, linein
            DO
                x = INSTR(linein, matchtext)
                IF x THEN
                    linein = LEFT$(linein, x - 1) & repltext & MID$(linein, x + matchlen)
                    ' If matchtext and repltext are of equal length (as in this example)
                    ' then you can replace the above line with this:
                    ' MID$(linein, x) = repltext
                    ' This is somewhat more efficient than having to rebuild the string.
                ELSE
                    EXIT DO
                END IF
            LOOP
        ' If matchtext and repltext are of equal length (as in this example), or repltext
        ' is longer than matchtext, you could just write back to the file while it's open
        ' in BINARY mode, like so:
        ' PUT #1, 1, linein
        ' But since there's no way to reduce the file size via BINARY and PUT, we do this:
        CLOSE
        OPEN filespec FOR OUTPUT AS 1
            PRINT #1, linein;
        CLOSE
        filespec = DIR$
    WEND
    L0 += 1
WEND
