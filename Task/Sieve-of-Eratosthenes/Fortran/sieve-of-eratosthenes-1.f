      PROGRAM MAIN
      INTEGER LI
      WRITE (6,100)
      READ  (5,110) LI
      call SOE(LI)
 100  FORMAT( 'Limit:' )
 110  FORMAT( I4 )
      STOP
      END

C --- SIEVE OF ERATOSTHENES ----------
      SUBROUTINE SOE( LI )
      INTEGER LI
      LOGICAL A(LI)
      INTEGER SL,P,I

      DO 10 I=1,LI
         A(I) = .TRUE.
 10   CONTINUE

      SL = INT(SQRT(REAL(LI)))
      A(1) = .FALSE.
      DO 30 P=2,SL
         IF ( .NOT. A(P) ) GOTO 30
         DO 20 I=P*P,LI,P
            A(I)=.FALSE.
 20      CONTINUE
 30   CONTINUE

      DO 40 I=2,LI
         IF ( A(I) ) WRITE(6,100) I
 40   CONTINUE

 100  FORMAT(I3)
      RETURN
      END
