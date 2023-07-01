C     ==================================================================
      PROGRAM JULIA
C     ------------------------------------------------------------------
      INTEGER    NMAP,NROW,NCOL
      COMPLEX*16 C
      PARAMETER(NMAP=11,NROW=40,NCOL=100,C=(-0.798D0,0.1618D0))
      CHARACTER*1 MAP(NMAP)
      DATA MAP /' ','.',':','-','=','+','*','#','%','$','@'/
      REAL*8      X(NCOL), Y(NROW)
      INTEGER     IR, IC, I, J, MX
      CHARACTER*1 CLR, LINE(NCOL)
      COMPLEX*16  Z

      MX = (NMAP-1)*5
      CALL LINSPACE( NCOL, X, -1.5D0,  1.5D0 )
      CALL LINSPACE( NROW, Y,  1.0D0, -1.0D0 )

      WRITE (*,*) C

      DO 110 IR=1,NROW
         DO 100 IC=1,NCOL
            Z = DCMPLX( X(IC), Y(IR) )
            I  = 1
            CLR = ' '
 10         CONTINUE
            Z = Z*Z + C
            IF ( 2.0D0 .LT. CDABS(Z) ) THEN
               CLR = MAP(MOD(I,NMAP-1)+1)
               GOTO 20
            END IF
            I = I + 1
            IF ( MX .GT. I ) GOTO 10
 20         CONTINUE
            LINE(IC) = CLR
 100     CONTINUE
         WRITE(*,*) (LINE(J),J=1,NCOL)
 110  CONTINUE

      STOP
      END

C     ==================================================================
      SUBROUTINE LINSPACE( N, A, S, F )
C     ------------------------------------------------------------------
      INTEGER N
      REAL*8  N A(N), S, F
      INTEGER I
      REAL*8  D
      D = (F-S)/DBLE(N-1)
      A(1) = S
      DO 10 I=2,N
         A(I) = A(I-1) + D
 10   CONTINUE
      RETURN
      END
