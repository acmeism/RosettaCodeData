      FUNCTION SUM(A,N)
       DIMENSION A(*)
        SUM = 0       !Unconditionally, clear SUM.
        DO I = 1,N    !There may be less than one element to sum.
          SUM = A(I) + SUM
        END DO        !Some early compilers executed a DO-loop at least once.
      END
