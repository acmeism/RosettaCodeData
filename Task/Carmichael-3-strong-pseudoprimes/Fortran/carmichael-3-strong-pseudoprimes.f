      LOGICAL FUNCTION ISPRIME(N)	!Ad-hoc, since N is not going to be big...
       INTEGER N			!Despite this intimidating allowance of 32 bits...
       INTEGER F			!A possible factor.
        ISPRIME = .FALSE.		!Most numbers aren't prime.
        DO F = 2,SQRT(DFLOAT(N))	!Wince...
          IF (MOD(N,F).EQ.0) RETURN	!Not even avoiding even numbers beyond two.
        END DO				!Nice and brief, though.
        ISPRIME = .TRUE.		!No factor found.
      END FUNCTION ISPRIME		!So, done. Hopefully, not often.

      PROGRAM CHASE
      INTEGER P1,P2,P3	!The three primes to be tested.
      INTEGER H3,D	!Assistants.
      INTEGER MSG	!File unit number.
      MSG = 6		!Standard output.
      WRITE (MSG,1)	!A heading would be good.
    1 FORMAT ("Carmichael numbers that are the product of three primes:"
     & /"    P1  x P2  x P3 =",9X,"C")
      DO P1 = 2,61	!Step through the specified range.
        IF (ISPRIME(P1)) THEN	!Selecting only the primes.
          DO H3 = 2,P1 - 1		!For 1 < H3 < P1.
            DO D = 1,H3 + P1 - 1		!For 0 < D < H3 + P1.
              IF (MOD((H3 + P1)*(P1 - 1),D).EQ.0	!Filter.
     &        .AND. (MOD(H3 + MOD(-P1**2,H3),H3) .EQ. MOD(D,H3))) THEN	!Beware MOD for negative numbers! MOD(-P1**2, may surprise...
                P2 = 1 + (P1 - 1)*(H3 + P1)/D	!Candidate for the second prime.
                IF (ISPRIME(P2)) THEN		!Is it prime?
                  P3 = 1 + P1*P2/H3			!Yes. Candidate for the third prime.
                  IF (ISPRIME(P3)) THEN			!Is it prime?
                    IF (MOD(P2*P3,P1 - 1).EQ.1) THEN		!Yes! Final test.
                      WRITE (MSG,2) P1,P2,P3, INT8(P1)*P2*P3		!Result!
    2                 FORMAT (3I6,I12)
                    END IF
                  END IF
                END IF
              END IF
            END DO
          END DO
        END IF
      END DO
      END
