Cast forth a twelve times table, suitable for chanting at school.
      INTEGER I,J	!Steppers.
      CHARACTER*52 ALINE	!Scratchpad.
      WRITE(6,1) (I,I = 1,12)	!Present the heading.
    1 FORMAT ("  ×|",12I4,/," --+",12("----"))	!Alas, can't do overprinting with underlines now.
      DO 3 I = 1,12		!Step down the lines.
        WRITE (ALINE,2) I,(I*J, J = 1,12)	!Prepare one line.
    2   FORMAT (I3,"|",12I4)		!Aligned with the heading.
        ALINE(5:1 + 4*I) = ""		!Scrub the unwanted part.
    3   WRITE (6,"(A)") ALINE		!Print the text.
      END	!"One one is one! One two is two! One three is three!...
