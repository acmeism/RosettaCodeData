Cast forth a twelve times table, suitable for chanting at school.
      INTEGER I,J	!Steppers.
      CHARACTER*16 FORMAT	!Scratchpad.
      WRITE(6,1) (I,I = 1,12)	!Present the heading.
    1 FORMAT ("  ×|",12I4,/," --+",12("----"))	!Alas, can't do overprinting with underlines now.
      DO 3 I = 1,12		!Step down the lines.
        WRITE (FORMAT,2) (I - 1)*4,13 - I	!Spacing for omitted fields, count of wanted fields.
    2   FORMAT ("(I3,'|',",I0,"X,",I0,"I4)")	!The format of the FORMAT statement.
    3   WRITE (6,FORMAT) I,(I*J, J = I,12)	!Use it.
      END	!"One one is one! One two is two! One three is three!...
