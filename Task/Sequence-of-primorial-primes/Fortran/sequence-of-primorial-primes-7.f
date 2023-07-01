        LOGICAL FUNCTION BIGMRPRIME(N,TRIALS)	!Could N be a prime number?
         USE DFPORT	!To get RAND, which returns a "random" number in 0.0 to 1.0. Inclusive.
         TYPE(BIGNUM) N		!The number to taste.
         INTEGER TRIALS		!The count of trials to make.
         INTEGER REM(N.LAST,N.LAST + 1:2*N.LAST)	!Table of remainders. See BMODMULT.
         INTEGER NR		!Notes the uppermost entry in the table. See BADDREM.
         INTEGER S		!Counts powers of two in N - 1.
         TYPE(BIGNUM) NL1	!Holds N - 1 for comparisons.
         TYPE(BIGNUM) D		!N - 1 with twos divided out.
         TYPE(BIGNUM) A		!A number in [2:N - 1]. Any number...
         TYPE(BIGNUM) X		!Scratchpad.
         INTEGER A1,N1		!Assistants for juggling a "random" number.
         INTEGER TRIAL,R	!Counters.
          IF (BIGBASE.LE.3) STOP "BIGMRPRIME: BigBase too small!"	!Multi-digit even for small numbers!
Catch some annoying cases.
          IF (N.LAST.EQ.1) THEN	!A single-digit number?
            IF (N.DIGIT(1).LE.4) THEN	!Yes. Some special values are known.
              BIGMRPRIME = N.DIGIT(1).GE.2 .AND. N.DIGIT(1).LE.3	!Like, the neighbours.
              RETURN		!Thus allow 2 to be reported as prime.
            END IF		!Yet, test for 2 as a possible factor for larger numbers.
          END IF		!Without struggling over SQRT and suchlike.
          BIGMRPRIME = .FALSE.	!Most numbers are not primes.
          IF (BIGMOD2(N).EQ.0) RETURN	!A single expression using .OR. risks always evaluating BOTH parts, damnit,
          IF (BIGMODN(N,3).EQ.0) RETURN	!Even for even numbers. Possibly doing so "in parallel" is no consolation.
          NR = N.LAST		!Clear the REM table. One short of the first REM entry.
Construct D such that N - 1 = D*2**S. By here, N is odd, and greater than three.
          D.LAST = N.LAST	!Could just put D = N,
          D.DIGIT(1:D.LAST) = N.DIGIT(1:D.LAST)	!But this copies only the digits in use.
          CALL BIGADDN(D,-1)	!Thus, D becomes an even number.
          NL1.LAST = D.LAST	!For later testing of X against N - 1,
          NL1.DIGIT(1:NL1.LAST) = D.DIGIT(1:D.LAST)	!Retain N - 1.
          N1 = MIN(20000000D0,BIGVALUE(NL1))	!Maximum value is N - 1 for smallish N.
          S = 1			!Since D is even, it has at least one power of two.
   10     CALL BIGDIVN(D,2)	!Divide out a power of two.
          IF (BIGMOD2(D).EQ.0) THEN	!If there is another,
            S = S + 1			!Count it,
            GO TO 10			!And divide it out also.
          END IF		!So, D is no longer even. N - 1 = D*2**S
Convince through repetition...
        T:DO TRIAL = 1,TRIALS	!Some trials come to a definite result.
            BIGMRCOUNT(TRIAL) = BIGMRCOUNT(TRIAL) + 1	!Count the attempts.
            A1 = RAND(0)*(N1 - 2) + 2	!For small N, the birthday problem. NB! RAND can generate 1.
            CALL BIGLOADN(A,A1)		!A1 is in (0 + 2) = 2 to N - 1 = (1*(N1 - 2) + 2).
c            CALL BIGMODEXP(X,N,A,D)	!X = A**D mod N.
            CALL BMODEXP(X,A,D)		!X = A**D mod N.
            IF (X.LAST.EQ.1 .AND. X.DIGIT(1).EQ.1) CYCLE T	!Pox. A prime yields these: 1 or NL1.
            IF (BIGSIGN(X,NL1).EQ.0) CYCLE T	!A test with .OR. might always evaluate both, damnit.
            DO R = 1,S - 1	!Step through the powers of two in N - 1.
              CALL BIGSQUARE(X)		!X**2 ...
              CALL BIGMOD(X,N)		! ... mod N
              IF (X.LAST.EQ.1 .AND. X.DIGIT(1).EQ.1) RETURN	!X = 1? Definitely composite. No prime does this.
              IF (BIGSIGN(X,NL1).EQ.0) CYCLE T	!Pox. Try something else.
            END DO		!Another power of two?
            RETURN		!Definitely composite.
          END DO T		!Have another try.
          BIGMRPRIME = .TRUE.	!Would further trials yield greater assurance?
         CONTAINS	!Special versions incorporating "mod" not just at the end.
          SUBROUTINE BMODMULT(A,B)	!A:=A*B mod N.
Calculates from the low-order end upwards, thus requiring a scratchpad. But it does not get the full A*B size.
           TYPE(BIGNUM) A,B	!The numbers.
           TYPE(BIGNUM) T	!The product is developed here.
           INTEGER IA,FA,LA	!For A: Index, First (highest order), Last (lowest order).
           INTEGER IB,FB	!For B: Index, First (highest order).
           INTEGER L		!Fingers a digit for a result.
           INTEGER*8 S		!Scratchpad for digit multiply and summation.
            IF ((BIGBASE - 1)*B.LAST.GE.HUGE(S)/(BIGBASE - 1))	!Max. digit product, summed,
     1       STOP "BMODMULT: too many B digits! Could overflow S!"	!Rather than only ever one at a time..
            IF (A.LAST + B.LAST .GT. BIGLIMIT + 1)	!The case when the topmost digit doesn't carry up one more.
     1       STOP "BigMult will overflow!"	!Fixed storage sizes.
            FA = 1		!Parallelogram parsing control, starting at the top right corner.
            FB = 1		!These finger the digits of the first column's topmost product.
            LA = 1		!And this the last A-digit of the column's products.
            T.LAST = 1		!Prepare to accumulate column sums.
            T.DIGIT(1) = 0	!Starting with zero.
            L = 0		!No digits have been produced.
Commence producing digits. Work down each column, starting with the low-order side in the school style.
            S = 0			!The grand sum, of many digit products.
   10       IB = FB			!Index of B's digit of the moment.
            DO IA = FA,LA,-1		!Accumulate, working down a column, though bottom to top would do also.
              S = INT8(A.DIGIT(IA))*B.DIGIT(IB) + S	!Another digit product added in.
              IB = IB + 1				!NB: IA + IB is constant in this loop.
            END DO			!It is the digit power, plus two since DIGIT arrays start with one.
            IF (S.LT.0) STOP "BModMult: S has flipped sign!"	!Oh dear. Maybe not.
            L = L + 1			!Another digit is ready.
            IF (L.GT.N.LAST) THEN	!Reached REM territory?
              CALL BADDREM(T,INT4(MOD(S,BIGBASE)),L)	!Yes. Add (digit at L)*remainder(L) to T.
             ELSE		!Otherwise, below N, just place the new digit.
              T.LAST = L			!Keep T in proper form.
              T.DIGIT(L) = MOD(S,BIGBASE)	!Place the digit.
            END IF			!The sum's digit is assimilated.
            S = S/BIGBASE		!The sum's carry to the next digit up.
Contemplate the parallelogram, working right to left...
          IF (FA .LT. A.LAST) THEN	!The topmost term of a column
            FA = FA + 1				!Starts with this A-digit.
          ELSE IF (FB .LT. B.LAST) THEN	!But after the topmost A-digit is reached,
            FB = FB + 1				!The column starts with higher B-digits.
          ELSE				!And when the topmost B-digit has been reached,
            DO WHILE(S > 0)		!We're done. Extend the carry into higher powers.
              L = L + 1				!Up a power, up a digit.
              IF (L.GT.BIGLIMIT) STOP "BModMult has overflowed!"	!Perhaps too far!
              IF (L.GT.N.LAST) THEN		!Higher than N yet?
                CALL BADDREM(T,INT4(MOD(S,BIGBASE)),L)	!High-order digits are reduced.
               ELSE				!But up to N, just place single digits.
                T.LAST = L				!Still in strict sequence.
                T.DIGIT(L) = MOD(S,BIGBASE)		!There being no existing occupant.
              END IF				!So much for that digit.
              S = S/BIGBASE			!Drop a power as we climb to a still higher digit.
            END DO			!Not necessarily one digit worth. It is the sum of many two-digit products.
            CALL BIGMOD(T,N)		!Apply the MOD to clear the rabble...
            A.LAST = T.LAST				!Copy T to A.
            A.DIGIT(1:A.LAST) = T.DIGIT(1:T.LAST)	!Just the digits.
            RETURN				!Escape
          END IF			!So much for the start elements of the parallelogram.
          IF (IB.GT.B.LAST) LA = LA + 1	!The lowest-order A-digit of a column.
          GO TO 10			!Peruse the diagram.
          END SUBROUTINE BMODMULT	!As shown in BIGMULT.
          SUBROUTINE BADDREM(B,A,L)	!B = B + A*REM(L)
           TYPE(BIGNUM) B	!To be augmented.
           INTEGER A		!The sum to be added to B.
           INTEGER L		!At this digit. Presume L > N.LAST.
           TYPE(BIGNUM) T	!Scratchpad.
           INTEGER*8 C		!A carry for the addition.
           INTEGER I		!A stepper.
            IF (L.LE.N.LAST) STOP "BADDREM: digit order confusion!"	!Limited REM coverage.
Could need further entries in my table of mod N remainders for powers of BIGBASE.
            DO WHILE(NR.LT.L)	!If digit L is not encompassed,
              NR = NR + 1		!Step onwards one.
              T.LAST = NR		!Prepare a number having NR digits.
              T.DIGIT(NR) = 1		!Its highest-order digit being one, in any base.
              T.DIGIT(1:NR - 1) = 0	!And all lower digits zero, whatever BIGBASE is.
              CALL BIGMOD(T,N)		!Determine its remainder, mod N.
              REM(1:T.LAST,NR) = T.DIGIT(1:T.LAST)	!Place the digits in my table.
              REM(T.LAST + 1:N.LAST,NR) = 0		!Possible leading zeroes.
            END DO		!And check afresh.
Check that B has enough digits in use to receive a remainder's digits
            IF (N.LAST.GT.B.LAST) THEN	!Save on such checks during each digit of the addition.
              B.DIGIT(B.LAST + 1:N.LAST) = 0	!By placing zero digits once.
              B.LAST = N.LAST		!Not all REM entries use all N.LAST digits either.
            END IF			!Anyway, suspicion rules.
Calculate B = B + A*REM(L), which is A times the remainder for digit L of a big number.
            C = 0		!No carry from a previous digit.
            DO I = 1,N.LAST	!Modulo N means each remainder has N.LAST digits. At most.
              C = INT8(A)*REM(I,L) + B.DIGIT(I) + C	!Some might have high-end zero digits.
              B.DIGIT(I) = MOD(C,BIGBASE)	!But no matter. Crunch them all.
              C = C/BIGBASE			!And carry on.
            END DO		!On to the next digit up
Carry on to higher digits, as needed.
            I = N.LAST	!Not relying on it being N.LAST + 1.
            DO WHILE (C > 0)	!Some more carry?
              I = I + 1			!Yes. Another digit up.
              IF (I.GT.B.LAST) THEN	!Beyond the current spread?
              	IF (I.GT.BIGLIMIT) STOP "BAddRem has overflowed!"	!Perhaps another digit?
                B.LAST = B.LAST + 1		!Yes. Have another.
                B.DIGIT(B.LAST) = MOD(C,BIGBASE)!Knowing B's digit was zero.
               ELSE		!Otherwise, B exists this far up from previous usage.
                C = C + B.DIGIT(I)	!Its digit is unlikely to be zero.
                B.DIGIT(I) = MOD(C,BIGBASE)	!Place the revised digit.
              END IF		!So much for that digit.
              C = C/BIGBASE	!Reduce the carry.
            END DO		!And check afresh.
            CALL BIGNORM(B)	!Cancel any unused high-order zeroes.
          END SUBROUTINE BADDREM!Well, that was confusing.
          SUBROUTINE BMODEXP(V,X,P)	!Calculate V = X**P mod N without overflowing...
C  Relies on a.b mod n = (a mod n)(b mod n) mod n
           TYPE(BIGNUM) V,X,P	!All presumed positive.
           TYPE(BIGNUM) I		!A stepper.
           TYPE(BIGNUM) W		!Broad scratchpads, otherwise N > 46340 may incur overflow in 32-bit.
            CALL BIGLOADN(V,1)		!=X**0
            IF (P.LAST.GT.1 .OR. P.DIGIT(1).GT.0) THEN	!Something to do?
              I.LAST = P.LAST				!Yes. Get a copy I can mess with.
              I.DIGIT(1:I.LAST) = P.DIGIT(1:P.LAST)	!Only copying the digits in use.
              W.LAST = X.LAST				!=X**1, X**2, X**4, X**8, ... except, all are mod N.
              W.DIGIT(1:W.LAST) = X.DIGIT(1:X.LAST)	!Used according to the bits in P.
    1         IF (BIGMOD2(I).EQ.1) THEN	!Incorporate W if the low-end calls for it.
c                CALL BIGMULT(V,W)			!V:=V*W ...
c                CALL BIGMOD(V,N)			!   ... mod N.
                CALL BMODMULT(V,W)			!V:=V*W mod N.
              END IF			!So much for that bit.
              CALL BIGDIVN(I,2)		!Used. Shift the next one down.
              IF (I.LAST.GT.1 .OR. I.DIGIT(1).GT.0) THEN	!Still something to do?
c                CALL BIGSQUARE(W)			!Yes. Square W ready for the next bit up.
c                CALL BIGMOD(W,N)			!Reduced modulo N.
                CALL BMODMULT(W,W)			!W*W mod N.
                GO TO 1				!Consider it.
              END IF			!Don't square W if nothing remains. A waste of effort.
            END IF		!Negative powers are ignored.
          END SUBROUTINE BMODEXP	!"Bit" presence by arithmetic: works for non-binary arithmetic too.
        END FUNCTION BIGMRPRIME	!Are some numbers resistant to this scheme?
