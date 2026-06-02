' ============================================
' https://rosettacode.org/wiki/File_input/output
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

[inits]
    LET inputFile$ = "input.txt"
    LET outputFile$ = "output.txt"
    LET content$

    ' Check if exists and if so, read it
    IF FileExists(inputFile$) = TRUE THEN
        PRINT "File: "; inputFile$; " exists. Reading contents."
        content$ = FileRead(inputFile$)
        PRINT "Content: "; content$

        ' Write to output.txt
        FileWrite outputFile$, content$
        PRINT "Content saved to file: "; outputFile$
    ELSE
        PRINT "File: "; inputFile$; " do not exist."
    END IF
END

' [file name='input.txt']
' The quick brown fox jumps over the lazy dog.
' Empty vessels make most noise.
' Too many chefs spoil the broth.
' A rolling stone gathers no moss.
' [/file]

' Output:
' File: input.txt exists. Reading contents.
' Content: The quick brown fox jumps over the lazy dog.
' Empty vessels make most noise.
' Too many chefs spoil the broth.
' A rolling stone gathers no moss.
' Content saved to file: output.txt
