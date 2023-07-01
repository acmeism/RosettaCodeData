      FUNCTION SUM(I,LO,HI,TERM)
        SUM = 0
        DO I = LO,HI
          SUM = SUM + TERM
        END DO
      END FUNCTION SUM
      WRITE (6,*) SUM(I,1,100,1.0/I)
      END
