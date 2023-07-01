      MODULE MRTEST	!Try the Miller-Rabin primality test.
       CONTAINS		!Working only with in-built integers.
        LOGICAL FUNCTION MRPRIME(N,TRIALS)	!Could N be a prime number?
         USE DFPORT	!To get RAND.
         INTEGER N	!The number.
         INTEGER TRIALS	!The count of trials to make.
         INTEGER D,S	!Represents a number in a special form.
         INTEGER TRIAL
         INTEGER A,X,R
Catch some annoying cases.
          IF (N .LE. 4) THEN	!A single-digit number?
            MRPRIME = N.GT.1 .AND. N.LE.3	!Yes. Some special values.
            RETURN		!Thus allow 2 to be reported as prime.
          END IF		!Yet, test for 2 as a possible factor for larger numbers.
          MRPRIME = .FALSE.	!Pessimism prevails.
          IF (MOD(N,2).EQ.0 .OR. MOD(N,3).EQ.0) RETURN	!Thus.
Construct D such that N - 1 = D*2**S. By here, N is odd, and greater than three.
          D = N - 1		!Thus, D becomes an even number.
          S = 1			!So, it has at least one power of two.
   10     D = D/2		!Divide it out.
          IF (MOD(D,2).EQ.0) THEN	!If there is another,
            S = S + 1			!Count it,
            GO TO 10			!And divide it out also.
          END IF		!So, D is no longer even. N = 1 + D*2**S
          WRITE (6,11) N,D,S
   11     FORMAT("For ",I0,", D=",I0,",S=",I0)
Convince through repetition..
        T:DO TRIAL = 1,TRIALS	!Some trials yield a definite result.
            A = RAND(0)*(N - 2) + 2	!For small N, the birthday problem.
            X = MODEXP(N,A,D)		!A**D mod N.
            WRITE (6,22) TRIAL,A,X,INT8(A)**D,N,MOD(INT8(A)**D,N)
   22       FORMAT(6X,"Trial ",I0,",A=",I4,",X=",I4,
     1       "=MOD(",I0,",",I0,")=",I0)
            IF (X.EQ.1 .OR. X.EQ.N - 1) CYCLE T	!Pox. A prime yields these.
            DO R = 1,S - 1	!Step through the powers of two in N - 1.
              X = MODEXP(N,X,2)		!X**2 mod N.
              WRITE (6,23) R,X
   23         FORMAT (14X,"R=",I4,",X=",I0)
              IF (X.EQ.1) RETURN	!Definitely composite. No prime does this.
              IF (X.EQ.N - 1) CYCLE T	!Pox. Try something else.
            END DO		!Another power of two?
            RETURN		!Definitely composite.
          END DO T		!Have another go.
          MRPRIME = .TRUE.	!Would further trials yield greater assurance?
        END FUNCTION MRPRIME	!Are some numbers resistant to this scheme?

        INTEGER FUNCTION MODEXP(N,X,P)	!Calculate X**P mod N without overflowing...
C  Relies on a.b mod n = (a mod n)(b mod n) mod n
         INTEGER N,X,P	!All presumed positive, and X < N.
         INTEGER I	!A stepper.
         INTEGER*8 V,W	!Broad scratchpads, otherwise N > 46340 may incur overflow in 32-bit.
          V = 1		!=X**0
          IF (P.GT.0) THEN	!Something to do?
            I = P			!Yes. Get a copy I can mess with.
            W = X			!=X**1, X**2, X**4, X**8, ... except, all are mod N.
    1       IF (MOD(I,2).EQ.1) V = MOD(V*W,N)	!Incorporate W if the low-end calls for it.
            I = I/2			!Used. Shift the next one down.
            IF (I.GT.0) THEN		!Still something to do?
              W = MOD(W**2,N)			!Yes. Square W ready for the next bit up.
              GO TO 1				!Consider it.
            END IF				!Don't square W if nothing remains. It might overflow.
          END IF		!Negative powers are ignored.
          MODEXP = V		!Done, in lb(P) iterations!
        END FUNCTION MODEXP	!"Bit" presence by arithmetic: works for non-binary arithmetic too.

      PROGRAM POKEMR
      USE MRTEST
      INTEGER I
      LOGICAL HIC

      DO I = 3,36,2
        HIC = MRPRIME(I,6)
        WRITE (6,11) I,HIC
   11   FORMAT (I6,1X,L)
      END DO

      END
