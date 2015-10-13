      SUBROUTINE TASTE(T)
       CHARACTER*(*) T       !This form allows for any size.
        IF (LEN(T).LE.0) WRITE(6,*) "Empty!"
        IF (LEN(T).GT.0) WRITE(6,*) "Not empty!"
      END
      CHARACTER*24 TEXT
      CALL TASTE("")
      CALL TASTE("This")
      TEXT = ""              !Fills the entire variable with space characters.
      CALL TASTE(TEXT)       !Passes all 24 of them. Result is Not empty!
      END
