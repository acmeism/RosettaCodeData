      INTEGER MANY,LONG
      PARAMETER (LONG = 6,MANY = 4)	!Adjust to suit.
      CHARACTER*(LONG) STRINGS(MANY)	!A list of text strings.
      STRINGS(1) = "Fee"
      STRINGS(2) = "Fie"
      STRINGS(3) = "Foe"
      STRINGS(4) = "Fum"
      IF (ALL(STRINGS(1:MANY - 1) .LT. STRINGS(2:MANY))) THEN
        WRITE (6,*) MANY," strings: strictly increasing in order."
       ELSE
        WRITE (6,*) MANY," strings: not strictly increasing in order."
      END IF
      IF (ALL(STRINGS(1:MANY - 1) .EQ. STRINGS(2:MANY))) THEN
        WRITE (6,*) MANY," strings: all equal."
       ELSE
        WRITE (6,*) MANY," strings: not all equal."
      END IF
      END
