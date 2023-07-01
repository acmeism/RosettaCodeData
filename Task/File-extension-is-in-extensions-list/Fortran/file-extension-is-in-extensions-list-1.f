        IT = ICHAR(TEXT(I:I)) - ICHAR("a")	!More symbols precede "a" than "A".
        IF (IT.GE.0 .AND. IT.LE.25) TEXT(I:I) = CHAR(IT + ICHAR("A"))	!In a-z? Convert!
