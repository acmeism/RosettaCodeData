      MODULE BIGNUMBERS	!Limited services: decimal integers, no negative numbers.
       INTEGER BIGORDER		!A limited attempt at generality.
       PARAMETER (BIGORDER = 4)	!This is the order of the base of the big number arithmetic.
       INTEGER BIGBASE,BIGLIMIT	!Sized thusly.
       PARAMETER (BIGBASE = 10**BIGORDER, BIGLIMIT = 8888/BIGORDER)	!Enough?
       TYPE BIGNUM	!So, a big number is simple.
        INTEGER LAST		!This many digits (of size BIGBASE) are in use.
        INTEGER DIGIT(BIGLIMIT)	!The digits, in ascending power order.
       END TYPE BIGNUM	!So much for that.
       INTEGER BIGLEADN	!Additional stuff for its rounding.
       PARAMETER (BIGLEADN = 8/BIGORDER)	!Sufficient digits to show. With a struggle.
       INTEGER BIGLEAD(BIGLEADN + 1)		!Followed by an exponent.
Collect some statistics on the working of BIGMRPRIME
       INTEGER BIGMRTRIALS		!How many trials, at most.
       PARAMETER (BIGMRTRIALS = 6)	!This might do.
       INTEGER BIGMRCOUNT(BIGMRTRIALS)	!BIGMRPRIME may not use all its trials.
       DATA BIGMRCOUNT/BIGMRTRIALS*0/	!None so far.
       CONTAINS		!Now for some assistants.
        SUBROUTINE BIGWRITE(F,B)	!Show B.
         INTEGER F	!I/O unit number.
         TYPE(BIGNUM) B	!The number.
          WRITE (F,1,ADVANCE="NO") B.DIGIT(B.LAST:1:-1)	!Roll the digits in base ten.
    1     FORMAT (665I<BIGORDER + 1>.<BIGORDER>)	!Leading zeroes after the first digit.
        END SUBROUTINE BIGWRITE		!Simple, but messy.

        INTEGER FUNCTION BIGSIGN(A,B)	!Sign(A - B) returns -ve, 0, +ve. Not just -1, 0, +1.
         TYPE(BIGNUM) A,B	!The two numbers.
         INTEGER L		!A finger.
          BIGSIGN = A.LAST - B.LAST	!Compare the number of digits.
          IF (BIGSIGN.EQ.0) THEN	!The same?
            DO L = A.LAST,1,-1			!Alas. Compare the digits themselves.
              BIGSIGN = A.DIGIT(L) - B.DIGIT(L)		!From the high-order, down.
              IF (BIGSIGN.NE.0) RETURN			!A difference yet?
            END DO				!Descend to the next pair of digits.
          END IF			!So much for shortcuts.
        END FUNCTION BIGSIGN	!Hopefully, not many digits will have to be compared.

        SUBROUTINE BIGLOADN(B,N)!B:=N	!Convert a normal number.
         TYPE(BIGNUM) B	!The multi-BIGBASE number.
         INTEGER N	!An ordinary number. Negatives need not apply.
         INTEGER C	!The carry.
          B.LAST = 1	!Start with one digit.
          C = N		!Perhaps more than one will be needed.
    1     B.DIGIT(B.LAST) = MOD(C,BIGBASE)	!Place the digit.
          C = C/BIGBASE		!Lose that digit.
          IF (C.GT.0) THEN	!More remains?
            B.LAST = B.LAST + 1		!Yes. Another digit is needed.
            GO TO 1			!And try again.
          END IF		!Just in case N >= BIGBASE.
        END SUBROUTINE BIGLOADN	!Worry over negative numbers sometime later.

        DOUBLE PRECISION FUNCTION BIGVALUE(B)	!Convert back to an ordinary number. Limited range!
         TYPE(BIGNUM) B	!The mysterious big number.
         REAL*8 F	!The mantissa to come. "Infinity" starts at ~10**306.
         INTEGER D	!Counts BIGBASE digits.
         INTEGER I	!A stepper.
          F = 0		!I'm not messing with negative numbers yet.
          D = 0		!No digits assimilated.
          DO I = B.LAST,MAX(1,B.LAST - 18/BIGORDER),-1	!Work from the high order down.
            D = D + 1			!Another one in.
            F = F*BIGBASE + B.DIGIT(I)	!Thus.
          END DO			!Perhaps more to come.
          BIGVALUE = F*DFLOAT(BIGBASE)**(B.LAST - D)	!Beware floating-point overflow!
        END FUNCTION BIGVALUE	!An alternative would be BIGLOG(B).

        SUBROUTINE BIGTASTE(B)	!Represent B in BIGLEAD as a floating-point number.
Copies the first few digits to BIGLEAD, with rounding, followed by the base ten exponent.
         TYPE(BIGNUM) B		!The number to taste.
         INTEGER L,IT		!Fingers.
         INTEGER D,E		!A digit and an exponent.
          IF (MOD(BIGBASE,10).NE.0) STOP "BIGTASTE expects powers of 10"	!Alas. Otherwise the "E" formalism fails.
          BIGLEAD = 0			!Scrub, on general principles.
          L = MIN(BIGLEADN,B.LAST)	!I'm looking to taste the leading digits; too few?.
          BIGLEAD(1:L) = B.DIGIT(B.LAST:B.LAST - L + 1:-1)	!Reverse, to have normal order.
          E = (B.LAST - 1)*BIGORDER	!Convert from 10**BIGORDER to base 10.
          D = B.DIGIT(B.LAST)		!Grab the high-order digit.
          DO WHILE(D.GT.0)		!It is not zero..
            E = E + 1			!So it is at least one base ten digit.
            D = D/10			!Snip.
          END DO			!And perhaps there will be more.
          D = 0				!We should consider rounding up.
          IF (B.LAST.GT.BIGLEADN) THEN	!Are there even more digits?
            IT = L			!Yes. This is now the low-order digit tasted.
            IF (B.DIGIT(B.LAST - L).GE.BIGBASE/2) D = 1	!If the next digit is big enough.
          C:DO WHILE (D.GT.0)		!Spread the carry.
              D = 0				!This one is used up.
              BIGLEAD(IT) = BIGLEAD(IT) + 1	!Thusly.
              IF (BIGLEAD(IT).GE.BIGBASE) THEN	!But, maybe, overflow!
                BIGLEAD(IT) = BIGLEAD(IT) - BIGBASE	!Yes!
                D = 1					!Reassert a carry.
                IT = IT - 1				!Step back to the next recipient up.
                IF (IT.LE.0) EXIT C			!If there isn't one, quit!
              END IF				!So much for that overflow.
            END DO C			!Mostly, a carry doesn't propagate far.
          END IF			!So, no test for IT > 0 in a compound "while".
          IF (D.NE.0) THEN	!If a carry remains, the rounding propagated all the way up!
            E = E + 1			!So, count another power of ten up.
            BIGLEAD(1) = 1		!And thus maintain the 0.etc. style.
c           BIGLEAD(2:) = 0		!These are already zero.
          END IF		!Enough carrying.
          BIGLEAD(BIGLEADN + 1) = E	!Place the exponent.
        END SUBROUTINE BIGTASTE	!That was messy.

        SUBROUTINE BIGNORM(B)	!Normalise B to avoide a horde of leading zero digits.
         TYPE(BIGNUM) B		!The number.
Can't rely on DO WHILE(B.LAST.GT.1 .AND. B.DIGIT(B.LAST)).NE.0)  beause *both* parts *might* be evaluated. Bah.
   10     IF (B.LAST.GT.1) THEN	!If B has a single digit only, it can be zero.
            IF (B.DIGIT(B.LAST).NE.0) RETURN	!If it is not zero, we're done.
            B.LAST = B.LAST - 1		!Otherwise, step down one digit,
            GO TO 10			!And check afresh.
          END IF		!So much for normalisation. Rather like floating-point numbers.
        END SUBROUTINE BIGNORM	!In memory of Norman Kirk, Labour party leader and prime minister.

        SUBROUTINE BIGADDN(B,N)	!B:=B + N	Add a (small) ordinary number to a big number.
         TYPE(BIGNUM) B	!The big number to be augmented.
         INTEGER N	!The addend. Should be smaller than the integer limit less BIGBASE.
         INTEGER I	!A stepper.
         INTEGER C,D	!Assistants for the arithmetic.
          C = N			!Start as if already in progress.
          DO I = 1,B.LAST	!Spread the carry to higher digits as needed.
            D = B.DIGIT(I) + C		!Thus.
            IF (D.GE.0) THEN		!Negative N might require a borrow.
              B.DIGIT(I) = MOD(D,BIGBASE)	!Not this time. Correct the digit.
              C = D/BIGBASE			!And calculate the carry to continue.
             ELSE			!Otherwise, borrow one from the next digit up.
              D = D + BIGBASE			!Thus.
              B.DIGIT(I) = MOD(D,BIGBASE)	!MOD for negative number can behave unexpectedly.
              C = D/BIGBASE - 1			!Repay the borrow.
            END IF			!So much for DIGIT(I).
            IF (C.EQ.0) RETURN		!Finished already?
          END DO		!On to the next digit up.
Completed work with the original number of digits in the big number.
          DO WHILE(C .NE. 0)	!Now spread the last carry to further digits.
            B.LAST = B.LAST + 1		!Up one more.
            IF (B.LAST .GT. BIGLIMIT) STOP "Overflow by addition!"	!Perhaps not.
            B.DIGIT(B.LAST) = MOD(C,BIGBASE)	!The digit.
            C = C/BIGBASE		!The carry may be large, if N is large.
          END DO		!So slog on until it is gone.
        END SUBROUTINE BIGADDN	!Negative  values for B are not considered.

        SUBROUTINE BIGMULTN(B,N)	!B:=B*N;	Multiply by an integer possibly bigger than the base.
         TYPE(BIGNUM) B	!The worker.
         INTEGER N	!A computer number, not a multi-digit number.
         INTEGER D	!Must be able to hold (BIGBASE - 1)*N + C
         INTEGER C	!The carry to the next digit.
         INTEGER*8 DD	!N may be large...
         INTEGER V	!Beware of BIGMULT(B,B); B.DIGIT(1) is N.
         INTEGER I	!A stepper.
          IF (N.EQ.1) RETURN	!Phooey.
          IF (N.EQ.0) THEN	!This takes a little more effort.
            B.LAST = 1			!One digit.
            B.DIGIT(1) = 0		!Zero.
            RETURN			!Done.
          END IF		!Otherwise, start work.
          V = N			!Grab a local copy in case of doubled reference.
          C = 0			!No previous digit to carry from.
          IF (N .LT. HUGE(D)/BIGBASE) THEN	!Can D hold N*BIGBASE?
            DO I = 1,B.LAST	!Step through the digits, upwards powers.
              D = B.DIGIT(I)*V + C	!Grab a digit and apply the multiply.
              B.DIGIT(I) = MOD(D,BIGBASE)	!Place the resulting digit.
              C = D/BIGBASE		!Agony! TWO divisions per step!!
            END DO		!On to the next digit up.
           ELSE		!Larger N means escalating to a proper double-digit product.
            DO I = 1,B.LAST	!Step through the same digits.
              DD = INT8(B.DIGIT(I))*V + C	!Grab a digit and apply the multiply.
              B.DIGIT(I) = MOD(DD,BIGBASE)	!Place the resulting digit.
              C = DD/BIGBASE		!Agony! TWO divisions per step!!
            END DO		!On to the next digit up.
          END IF		!Either way, the carry is a single digit.
          DO WHILE(C .GT. 0)	!Now spread the last carry to further digits.
            B.LAST = B.LAST + 1		!Up one more.
            IF (B.LAST .GT. BIGLIMIT) STOP "Overflow by multiply!"	!Perhaps not.
            B.DIGIT(B.LAST) = MOD(C,BIGBASE)	!The digit.
            C = C/BIGBASE		!The carry may be large, if N is large.
          END DO		!So slog on until it is gone.
        END SUBROUTINE BIGMULTN	!Primary school stuff.

        SUBROUTINE BIGMULT(A,B)	!A:=A*B, and yes, BIGMULT(A,A) will square A.
C   Calculates from the high-order end downwards, with carries going against that flow.
C   This enables the result to be calculated in-place, even with BIGMULT(A,A).
C
C                                 a5   a4   a3   a2   a1  ...Five digits.
c                                  x   b4   b3   b2   b1  ...Four digits.
c              -----------------------------------------
c                               a5b1 a4b1 a3b1 a2b1 a1b1
c                          a5b2 a4b2 a3b2 a2b2 a1b2      ... five wide.
c                     a5b3 a4b3 a3b3 a2b3 a1b3           ... four high.
c                a5b4 a4b4 a3b4 a2b4 a1b4
c          ---------------------------------------------
c          carry    8    7    6    5    4    3    2    1  At most nine digits.
c          ---------------------------------------------
C   A column sum of many digit products might overflow S given many B digits and a big base.
         TYPE(BIGNUM) A,B	!The numbers.
         INTEGER IA,FA,LA	!For A: Index, First (highest order), Last (lowest order).
         INTEGER IB,FB,LB	!For B: Index, First (highest order), Last (lowest order).
         INTEGER L		!Fingers a digit for a result.
         INTEGER*8 S		!Scratchpad for digit multiply and summation.
          IF ((BIGBASE - 1)*B.LAST.GE.HUGE(S)/(BIGBASE - 1))	!Max. digit product, summed,
     1     STOP "BIGMULT: too many B digits! Could overflow S!"	!Rather than only ever one at a time..
Check for some simple situations in the hope of evading big nullities.
          LB = B.LAST		!I'll need a copy of the original layout.
          IF (LB.EQ.1) THEN	!A single digit B may have some special values.
            IF (B.DIGIT(1).EQ.0) THEN	!Multiplying A by zero?
              CALL BIGLOADN(A,0)		!Easy.
            ELSE IF (B.DIGIT(1).NE.1) THEN	!And if we're not multiplying by one,
              CALL BIGMULTN(A,B.DIGIT(1))		!This is easier.
            END IF			!These values do not appear at random.
            RETURN			!Done.
          END IF		!Single-digit big numbers? Hummm.
          LA = A.LAST		!Copy for later also.
          IF (LA.EQ.1) THEN		!Perhaps a single-digit here instead..
            IF (A.DIGIT(1).EQ.0) RETURN	!Zero times something? Zero!
            IF (A.DIGIT(1).EQ.1) THEN	!One times something?
              A.LAST = B.LAST			!Yes!
              A.DIGIT(1:A.LAST) = B.DIGIT(1:B.LAST)	!Copy that something.
              RETURN				!That was easy.
            END IF			!So much for one.
          END IF			!Might as well avoid wasted effort.
Can't avoid work any longer. If the big numbers are *big*, then a lot can be avoided. But, single-digits surely would be rare?
          IF (LA + LB .GT. BIGLIMIT + 1) STOP "BigMult will overflow!"	!Fixed storage sizes.
          A.LAST = LA + LB - 1		!Where the first result digit will go.
          FA = LA			!Parallelogram parsing control.
          FB = LB			!These finger the high-order digit.
Commence producing digits. Work down each column, starting with the high-order side.
          S = 0				!The grand sum, of many digit products.
   10     IB = FB			!Index of B's digit of the moment.
          DO IA = FA,LA,-1		!Accumulate, working down a column, though bottom to top would do also.
            S = INT8(A.DIGIT(IA))*B.DIGIT(IB) + S	!Another digit product added in.
            IB = IB + 1					!NB: IA + IB is constant in this loop.
          END DO			!It is the digit power, plus two since DIGIT arrays start with one.
          IF (S.LT.0) STOP "BIGMULT: S has flipped sign!"	!Oh dear.
          L = FA + FB - 1		!Finger the recipient digit.
          A.DIGIT(L) = MOD(S,BIGBASE)	!Place the digit.
Completed the column sum. Now spread any carry into higher digits as necessary.
          S = S/BIGBASE			!The sum's carry to the next digit up.
          DO WHILE(S > 0)		!It may well be multi-digit itself, being the sum of many digit products.
            L = L + 1				!Go back (up) a power.
            IF (L.LE.A.LAST) THEN		!Since we're going high to low,
              S = S + A.DIGIT(L)			!We add to prior work as we go back up.
             ELSE				!Or else (once, sigh), extending.
              A.LAST = L				!Because the high-order product carried up one.
              IF (L.GE.BIGLIMIT) STOP "BigMult has overflowed!"	!Perhaps too far!
            END IF			!Righto, S is ready.
            A.DIGIT(L) = MOD(S,BIGBASE)	!Place the digit.
            S = S/BIGBASE		!Drop a power as we climb to a still higher digit.
          END DO			!This may be many powers large.
Contemplate the parallelogram.
          IF (FB.GT.1) THEN		!The topmost term of a column
            FB = FB - 1			!Starts with this B-digit.
          ELSE IF (FA.GT.1) THEN	!But after the units B-digit is reached,
            FA = FA - 1			!The column starts with lesser A-digits.
          ELSE				!And when the units A-digit has been reached,
            RETURN			!We're done.
          END IF			!So much for the start elements of the parallelogram.
          IF (LA.GT.1) LA = LA - 1	!The lowest-order A-digit of a column.
          GO TO 10			!Peruse the diagram.
        END SUBROUTINE BIGMULT	!Not the Primary School order, but equivalent.

        SUBROUTINE BIGSQUARE(B)	!B:=B*B.
c     The special feature here is that half the effort of digit multiplying can be avoided by noting
c  that many digit products are paired, since Bi*Bj = Bj*Bi. Working along the rows from right to left
c  in the usual manner is easy: start with the Bi*Bi term, then roll along adding 2*Bi*Bj terms in long arithmetic.
c  The loop control is simple enough, but the doubling requirement is annoying since with fully-packed words
c  there would be overflows to deal with. Another way is to go down the columns.
c     "But you still have to double the terms" said Bruce Christianson, whom I met on the way back from lunch.
c     "Yes, but this way you can add them all up and double them once at the end."
c     Howl of anguish from Bruce, bewildered blinking from me: "What did I say?"
c     Bruce had spent most of a lunchtime discussing with John Rumsey, VAX expert, the opportunities offered
c  by Digital's VAX cpu, especially the feature that allows custom microcode to be loaded for unused op-codes
c  and which might help with the irritating task of the doubling of each term...
c     Actually, this can be done in yet a third way, in two passes: first, form the result (with no doubling)
c  and no squared terms (that are not to be doubled) in any way convenient, then in the second pass,
c  perform the doubling and add in the squared terms. Running along the rows has the advantage that
c  one of the digits is constant, so only the other has to be extracted from the array.
c     But, results must be placed in array elements, so there would still be two array accesses per step.
c
C
C                                          b6    b5    b4    b3    b2    b1  ... Six digits.
c                                        x b6    b5    b4    b3    b2    b1
c   -----------------------------------------------------------------------
c                                        b6b1  b5b1  b4b1  b3b1  b2b1  b1b1
c                                  b6b2  b5b2  b4b2  b3b2  b2b2  b1b2        ... six wide.
c                            b6b3  b5b3  b4b3  b3b3  b2b3  b1b3              ... six high.
c                      b6b4  b5b4  b4b4  b3b4  b2b4  b1b4
c                b6b5  b5b5  b4b5  b3b5  b2b5  b1b5
c          b6b6  b5b6  b4b6  b3b6  b2b6  b1b6
c
c   But, since b2b1 = b1b2, etc.,
c
c                                      |2b6b1 2b5b1|2b4b1 2b3b1|2b2b1  b1b1  ... six,
c                                 2b6b2|2b5b2 2b4b2|2b3b2  b2b2|             ... five,
c                          |2b6b3 2b5b3|2b4b3  b3b3|           |             ... four,
c                     2b6b4|2b5b4  b4b4|           |           |             ... three,
c              |2b6b5  b5b5|           |           |           |             ... two,
c          b6b6|           |           |           |           |             ... one.
c   -----------------------------------------------------------------------
c   carry    11    10     9     8     7     6     5     4     3     2     1  At most twelve digits.
c   -----------------------------------------------------------------------
C  A column sum of many digit products might overflow S given many B digits and a big base.
c  Working from the high-order end downwards (with carries going against that flow) enables the result to be calculated in-place.
         TYPE(BIGNUM) B	!The number to be squared.
         INTEGER FA,LA	!Index for the first and last of the lead digit in the mixed digit products. a6 in a6a5, etc.
         INTEGER FB	!Index for the first of the second digit in the product pairs.
         INTEGER IA,IB	!Index for the first and second parts of each digit product a5a4, etc.
         INTEGER L	!Fingers a digit for a result.
         INTEGER*8 S	!Scratchpad for digit multiply and summation.
         LOGICAL FLIP	!Some columns have a lone term, others have only doubled terms.
c          write (6,*) "B-digit limit",HUGE(S)/INT8(BIGBASE - 1)**2
          IF ((BIGBASE - 1)*B.LAST.GE.HUGE(S)/(BIGBASE - 1))	!Max. digit product, summed,
     1     STOP "BIGSQUARE: too many B digits! Could overflow S!"	!Rather than only ever one at a time..
Check for some simple situations in the hope of evading big nullities.
          FB = B.LAST		!I'll need a copy of the original layout.
          IF (FB.EQ.1) THEN	!A single digit B doesn't have many digits.
            CALL BIGMULTN(B,B.DIGIT(1))		!This is easier.
            RETURN			!Done.
          END IF		!Single-digit big numbers? Hummm.
Can't avoid work any longer. If the big numbers are *big*, then a lot can be avoided. But, single-digits surely would be rare?
          L = 2*FB - 1		!Locate the highest order product: b6b6 in the schedule.
          IF (L .GT. BIGLIMIT) STOP "BigSquare will overflow!"	!Fixed storage sizes.
          B.DIGIT(FB + 1:L) = 0	!Scrub, ready for carry propagation.
          B.LAST = L		!This might be extended by one.
          FA = FB		!Triangle parsing control. These finger the high-order digit.
          LA = FA + 1		!Syncopation: the a6a6 lone term has no sum of doubled products.
          FLIP = .TRUE.		!So the first loop for them won't. L is odd.
Commence producing digits. Work down each column, starting with the high-order side.
          S = 0			!The grand sum, of many digit products.
   10     IB = FB			!Index of the second digit in each product.
          DO IA = FA,LA,-1		!Accumulate, working down a column, though bottom to top would do also.
            S = INT8(B.DIGIT(IA))*B.DIGIT(IB) + S	!Another digit product added in.
            IB = IB + 1					!NB: IA + IB is constant in this loop.
          END DO			!It is the digit power, plus two since DIGIT arrays start with one..
          S = S + S			!Thus the sum of the 2* terms in one go...
          IF (FLIP) THEN		!For odd powers, there is also an undoubled product.
            LA = LA - 1				!Its index is one less than the last digit for a doubled product.
            S = S + INT8(B.DIGIT(LA))**2	!Another chance for overflowing S.
          END IF			!The column sum is now complete.
          IF (S.LT.0) STOP "BigSquare: S has flipped sign!"	!Oh dear.
          FLIP = .NOT.FLIP		!Thus the adjustment on every odd power of the result.
          L = FA + FB - 1		!Finger the recipient digit.
          B.DIGIT(L) = MOD(S,BIGBASE)	!Place the digit.
Completed the column sum. Now spread any carry into higher digits as necessary.
          S = S/BIGBASE			!The sum's carry to the next digit up.
          DO WHILE(S > 0)		!It may well be multi-digit itself, being the sum of many digit products.
            L = L + 1				!Go back (up) a power.
            IF (L.LE.B.LAST) THEN		!Since we're going high to low,
              S = S + B.DIGIT(L)			!We add to prior work as we go back up.
             ELSE				!Or else (once, sigh), extending.
              B.LAST = L				!Because the high-order product carried up one.
              IF (L.GE.BIGLIMIT) STOP "BIGSQUARE has overflowed!"	!Perhaps too far.
            END IF			!Righto, S is ready.
            B.DIGIT(L) = MOD(S,BIGBASE)	!Place the digit.
            S = S/BIGBASE		!Drop a power as we climb to a still higher digit.
          END DO			!This may be many powers large for big summations.
Contemplate the parallelogram.
          IF (FB.GT.1) THEN		!The topmost term of a column
            FB = FB - 1			!Starts with this second digit of each product pair.
          ELSE IF (FA.GT.1) THEN	!But after the units is reached,
            FA = FA - 1			!The column starts with lesser first digits.
          ELSE				!And when the units first digit has been reached,
            RETURN			!We're done.
          END IF			!So much for the start elements of the parallelogram.
          GO TO 10			!Peruse the diagram.
        END SUBROUTINE BIGSQUARE	!Not the Primary School order, but equivalent.

        INTEGER FUNCTION BIGMOD2(B)	!B mod 2.
         TYPE(BIGNUM) B		!The number.
Compilers ought to notice that BIGBASE is a constant, so MOD(BIGBASE,2).EQ.0 is also constant, and not generate pointless code...
Could also hope that MOD 2 will be effected via an "and" on binary computers.
          IF (MOD(BIGBASE,2).EQ.0) THEN	!If the base is even,
            BIGMOD2 = MOD(B.DIGIT(1),2)		!Only the units digit need be considered.
           ELSE				!But for odd bases, each digit must be inspected.
            BIGMOD2 = MOD(COUNT(MOD(B.DIGIT(1:B.LAST),2) .EQ. 1),2)	!Whee!
          END IF			!That was fun!
        END FUNCTION BIGMOD2	!This should be swifter than BIGMODN(B,2)

        INTEGER FUNCTION BIGMODN(B,N)	!Calculate MOD(B,N), for ordinary N.
Causes 32-bit overflow if any C*BIGBASE + DIGIT(i) exceeds the 32-bit integer limit.
         TYPE(BIGNUM) B	!The big number, presumed positive.
         INTEGER N	!The divisor, presumed positive.
         INTEGER I	!The stepper.
         INTEGER C	!The carry. Values are in 0:N - 1.
          IF (N.LE.0) STOP "BIGMODN: positive divisors only!"	!Grr.
C         IF (N.GT.46340) STOP "BIGMODN: N limited to 46340!"	!If INT8, etc. is unavailable.
          C = 0			!Here we go.                      carry          +  digit
          IF (N.GE.HUGE(C)/BIGBASE) THEN	!Maximum term is (N - 1)*BIGBASE + (BIGBASE - 1).
            DO I = B.LAST,1,-1			!So, N*BIGBASE - 1 must not exceed HUGE(C).
              C = MOD(C*INT8(BIGBASE) + B.DIGIT(I),N)	!Or, N*BIGBASE .GT. HUGE(C) + 1.
            END DO		!Next digit down.	!Or, N         .GT. HUGE(C)/BIGBASE + 1/BIGBASE
           ELSE		!Thus, if N is not so big, no escalation is needed.
            DO I = B.LAST,1,-1	!From the highest-order digit, downwards.
              C = MOD(C*BIGBASE + B.DIGIT(I),N)	!Whee!
            END DO		!Next digit down.
          END IF	!If INTEGER*8 is not available, then a proper BIGMODN is needed.
          BIGMODN = C	!The remainder.
        END FUNCTION BIGMODN	!A simple idea, made complex.

        SUBROUTINE BIGMOD(B,M)	!B:=B mod M.
c  Clear? Hah! Why a four year old child could understand this.
c  Run out and find me a four year old child, I can't make head or tail out of it.
C          Groucho Marx as Rufus T. Firefly in Duck Soup. 18min.
         TYPE(BIGNUM) B	!The number, and the result.
         TYPE(BIGNUM) M	!The modulus.
         INTEGER L	!Location in B of M's high-order digit.
         INTEGER IB,IM	!Fingers to the digits of B and M.
         INTEGER Q,P	!Quotient and provisional reversal.
         INTEGER C	!Carry.
         INTEGER*8 DD,MM!Working numbers. BIGBASE might be large...
          IF (HUGE(DD).LT.FLOAT(BIGBASE - 1)**3) STOP "BIGBASE too big!"	!Triple digit size.
Could be easy...
          IF (M.LAST.LE.1) THEN	!Perhaps a single-digit divisor?
            B.DIGIT(1) = BIGMODN(B,M.DIGIT(1))	!Yes! This is much easier.
            B.LAST = 1				!A single-digit result.
            RETURN			!Done. Digits above B.LAST should not be referenced.
          END IF		!Otherwise, the fun begins. By here, know that M.LAST > 1.
          MM = M.DIGIT(M.LAST)*INT8(BIGBASE) + M.DIGIT(M.LAST - 1)	!Min. is BIGBASE, = 10 in every base.
Could still be easy...
    1     IF (BIGSIGN(B,M)) 3,2,10	!Sign of B - M.
    2     B.LAST = 1			!B = M.
          B.DIGIT(1) = 0		!Unlikely, but the result is clear.
    3     RETURN			!B < M: no change.
Can't evade the calculation via detection of silly parameters. Now know that B > M, and so B also has at least two digits.
   10     L = B.LAST		!Align M to the high-order digit of B.
          DD = B.DIGIT(L)*INT8(BIGBASE) + B.DIGIT(L - 1)	!Combine the top two digits of B. Max. is (b - 1)*b + (b - 1) = b² - 1.
          Q = DD/MM	!Estimate the quotient. Max. is BIGBASE - 1, because MM is two digits. Max is (max of DD)/(min of MM; b) = b - 1/b.
          IF (Q.LE.0) THEN		!E.g. in b = 10, 100 mod 11: 10/11 gives Q = 0. Thus know DD < MM.
            L = L - 1			!Move M one over. Must be possible, because B > M.
            Q = (DD*BIGBASE + B.DIGIT(L - 1))/MM	!But this requires three-digit arithmetic.
          END IF		!A quotient has been chosen.
Calculate B = B - Q*M, with M aligned to the high order of B via L.
   20     C = 0		!Clear the carry, which for subtraction is a "borrow".
          IB = L - M.LAST + 1	!Finger the lowest-order in B that is aligned with M's lowest order.
          DO IM = 1,M.LAST	!Step up through the digits of M.
            DD = C + B.DIGIT(IB) - INT8(Q)*M.DIGIT(IM)	!Subtract Q*M. Q may be BIGBASE - 1 so a double size result.
            IF (DD.LT.0) THEN	!Is a borrow needed?
              C = (DD + 1)/BIGBASE - 1		!Yes. Perhaps many, if Q > 1. C is negative.
              B.DIGIT(IB) = DD - C*BIGBASE	!Borrowing -C lots of BIGBASE produces one digit.
             ELSE		!Otherwise, a positive digit.
              B.DIGIT(IB) = DD		!No need for MOD(DD,BIGBASE).
              C = 0			!Clear any carry.
            END IF		!So much for that digit.
            IB = IB + 1		!Advance one digit up in B.
          END DO		!And also one digit up in M.
          IF (IB.EQ.B.LAST) THEN!If M had been shifted one over,
            DD = C + B.DIGIT(B.LAST)	!The top digit in B has no corresponding Q*M digit
            IF (DD.LT.0) THEN		!A borrow for the topmost digit?
              C = (DD + 1)/BIGBASE - 1		!Yes. This many.
              B.DIGIT(IB) = DD - C*BIGBASE	!Correct the digit.
             ELSE			!But without a borrow,
              B.DIGIT(IB) = DD			!No need for MOD(DD,BIGBASE)
              C = 0				!Clear any previous carry.
            END IF			!So much for the lonely topmost digit.
          END IF		!The carry may not be zero, and if so, upper digits of B are complemented in BIGBASE.
Check for overflow. Q might have been too big, when using M instead of just MM. Hopefully, not by much.
Consider 1005/101 in base 10. DD = 10, MM = 10 so Q = 1 above: proceed. But, subtracting 101 from 100|5 overflows.
Could add back the 101 then shift (and try afresh), or, shift and add back. Quotient is down 10 up 1, thus, down 9.
   30     IF (C.LT.0) THEN	!Has there been a borrow for the highest digit?
   31       C = C*INT8(BIGBASE) + B.DIGIT(L)	!Yes. Reconcile the two.
            IF (C.EQ.-1 .AND. L.GT.M.LAST) THEN	!The borrow came from below?
              L = L - 1				!Yes. Shift M along one, if not already all the way.
              GO TO 31				!And reconcile further. B - Q*M may clear more than one digit.
            END IF			!C is negative, and digit-sized.
            DD = C*INT8(BIGBASE) + B.DIGIT(L - 1)	!The overshoot, a negative number.
            P = 1 - DD/MM	!Convert to multiples of MM, possibly shifted further.
            IB = L - M.LAST + 1	!M's units digit is aligned with this B digit.
            C = 0		!Restart, unworried by the existing overflow..
            DO IM = 1,M.LAST	!Step through the digits of M.
              DD = C + B.DIGIT(IB) + INT8(P)*M.DIGIT(IM)	!Add in P*M.
              B.DIGIT(IB) = MOD(DD,BIGBASE)	!Place the digit.
              C = DD/BIGBASE			!Another divide for the carry.
              IB = IB + 1	!Step up one digit in B
            END DO		!And also one digit in M.
            DO IB = IB,B.LAST	!Convert any higher inverted digits.
              C = C + B.DIGIT(IB)	!C is one, and an inverted digit = (BIGBASE - 1).
              B.DIGIT(IB) = MOD(C,BIGBASE)	!So, this will be zero.
              C = C/BIGBASE		!And C will be one again.
            END DO		!All the way to the top of the number.
          END IF		!So much for any overflow.
Contemplate the result.
          CALL BIGNORM(B)	!Hopefully, many leading zero digits have appeared...
          IF (B.LAST.GT.M.LAST) GO TO 10!If B has more digits, there is definitely more to do.
          GO TO 1		!Possibly, B <= M.
        END SUBROUTINE BIGMOD	!Memories of a hand-cranked adding machine.

        INTEGER FUNCTION BIGDIVRN(B,N)	!B:=B/N; but, returns the remainder too.
         TYPE(BIGNUM) B	!The big number, presumed positive, to be divided by N..
         INTEGER N	!The divisor, presumed positive.
         INTEGER I	!The stepper.
         INTEGER R	!The remainder. Values are in 0:N - 1.
         INTEGER D	!A double digit, if N is not too big..
         INTEGER*8 DD	!For use with the larger values of N.
c         IF (N.GT.46340) STOP "BIGDIVRN: N limited to 46340!"	!If INT8, etc. is unavailable.
          R = 0		!Here we go.
          IF (N.GE.HUGE(D)/BIGBASE) THEN!Edging towards multi-precision arithmetic?
            DO I = B.LAST,1,-1	!Step down the digits.
              DD = R*INT8(BIGBASE) + B.DIGIT(I)	!Form the current digit.
              B.DIGIT(I) = DD/N		!Place it.
              R = MOD(DD,N)		!Remainder = R - B.DIGIT(I)*N, in primary school.
            END DO		!On to the next digit.
           ELSE		!If a remainder*BIGBASE + digit can fit into D, no need for DD.
            DO I = B.LAST,1,-1	!Step down the digits.
              D = R*BIGBASE + B.DIGIT(I)!Form the current digit.
              B.DIGIT(I) = D/N		!Place it.
              R = MOD(D,N)		!Remainder = D - B.DIGIT(I)*N, in primary school.
            END DO		!On to the next digit.
          END IF		!In larger or smaller gulps.
          CALL BIGNORM(B)	!Trim any leading zero digits.
          BIGDIVRN = R		!Pass back the remainder as well.
        END FUNCTION BIGDIVRN	!A pity that two divides per step can't be dodged outside assembler.

        SUBROUTINE BIGDIVN(B,N)	!B:=B div N	!Divide a big number by an ordinary number.
         TYPE(BIGNUM) B	!The big number to divide.
         INTEGER N	!The divisor, an ordinary number.
         INTEGER D,R	!Scratchpads for the calculation.
         INTEGER*8 DD	!A double-size digit is available...
         INTEGER I	!A stepper.
          IF (N.LE.0) STOP "BIGDIVN: positive divisors only!"	!Grr.
C         IF (N.GT.46340) STOP "BIGDIVN: N limited to 46340!"	!If INT8, etc. is unavailable.
          IF (N.EQ.1) GO TO 10	!Nothing need be done, but normalisation might be good.
          R = 0		!No higher-order remainder.
          IF (N.GE.HUGE(D)/BIGBASE) THEN!Edging towards multi-precision arithmetic?
            DO I = B.LAST,1,-1		!Starting at the high-order end and working down.
              DD = R*INT8(BIGBASE) + B.DIGIT(I)	!A term, double-digit size.
              B.DIGIT(I) = DD/N			!Divide, losing any remainder.
              R = MOD(DD,N)			!Max. remainder is N - 1.
            END DO			!On to the next digit, multiplying the remainder by BIGBASE.
           ELSE		!With N not large, (N - 1)*BIGBASE + DIGIT won't overflow.
            DO I = B.LAST,1,-1		!Starting at the high-order end and working down.
              D = R*BIGBASE + B.DIGIT(I)	!A term, double-digit size being not too big for D.
              B.DIGIT(I) = D/N			!Divide, losing any remainder.
              R = MOD(D,N)			!Recover the remainder.
            END DO			!On to the next digit.
          END IF	!Either way, this is as taught in primary school, except there R = D - B.DIGIT(I)*N.
   10     CALL BIGNORM(B)	!Check for leading zero digits, since B will have been reduced.
        END SUBROUTINE BIGDIVN	!The remainder could be returned as well.

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

        SUBROUTINE BIGMODEXP(V,N,X,P)	!Calculate V = X**P mod N without overflowing...
C  Relies on a.b mod n = (a mod n)(b mod n) mod n
         TYPE(BIGNUM) V,N,X,P	!All presumed positive.
         TYPE(BIGNUM) I		!A stepper.
         TYPE(BIGNUM) W		!Broad scratchpads, otherwise N > 46340 may incur overflow in 32-bit.
          CALL BIGLOADN(V,1)		!=X**0
          IF (P.LAST.GT.1 .OR. P.DIGIT(1).GT.0) THEN	!Something to do?
            I.LAST = P.LAST				!Yes. Get a copy I can mess with.
            I.DIGIT(1:I.LAST) = P.DIGIT(1:P.LAST)	!Only copying the digits in use.
            W.LAST = X.LAST				!=X**1, X**2, X**4, X**8, ... except, all are mod N.
            W.DIGIT(1:W.LAST) = X.DIGIT(1:X.LAST)	!Used according to the bits in P.
    1       IF (BIGMOD2(I).EQ.1) THEN	!Incorporate W if the low-end calls for it.
              CALL BIGMULT(V,W)			!V:=V*W ...
              CALL BIGMOD(V,N)			!   ... mod N.
            END IF			!So much for that bit.
            CALL BIGDIVN(I,2)		!Used. Shift the next one down.
            IF (I.LAST.GT.1 .OR. I.DIGIT(1).GT.0) THEN	!Still something to do?
              CALL BIGSQUARE(W)			!Yes. Square W ready for the next bit up.
              CALL BIGMOD(W,N)			!Reduced modulo N.
              GO TO 1				!Consider it.
            END IF			!Don't square W if nothing remains. A waste of effort.
          END IF		!Negative powers are ignored.
        END SUBROUTINE BIGMODEXP	!"Bit" presence by arithmetic: works for non-binary arithmetic too.

        LOGICAL FUNCTION BIGMRPRIME(N,TRIALS)	!Could N be a prime number?
         USE DFPORT	!To get RAND, which returns a "random" number in 0.0 to 1.0. Inclusive.
         TYPE(BIGNUM) N		!The number to taste.
         INTEGER TRIALS		!The count of trials to make.
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
Construct D such that N - 1 = D*2**S. By here, N is odd, and greater than three.
          D.LAST = N.LAST	!Could just put D = N,
          D.DIGIT(1:D.LAST) = N.DIGIT(1:D.LAST)	!But this copies only the digits in use.
          CALL BIGADDN(D,-1)	!Thus, D becomes an even number.
          NL1.LAST = D.LAST	!For later testing of X against N - 1,
          NL1.DIGIT(1:NL1.LAST) = D.DIGIT(1:D.LAST)	!Retain N - 1.
          N1 = MIN(20000000D0,BIGVALUE(NL1))	!Maximum value is N - 1.
          S = 1			!Since D is even, it has at least one power of two.
   10     CALL BIGDIVN(D,2)	!Divide out a power of two.
          IF (BIGMOD2(D).EQ.0) THEN	!If there is another,
            S = S + 1			!Count it,
            GO TO 10			!And divide it out also.
          END IF		!So, D is no longer even. N - 1 = D*2**S
Convince through repetition...
        T:DO TRIAL = 1,TRIALS	!Some trials come to a definite result.
            BIGMRCOUNT(TRIAL) = BIGMRCOUNT(TRIAL) + 1	!
            A1 = RAND(0)*(N1 - 2) + 2	!For small N, the birthday problem. NB! RAND can generate 1.
            CALL BIGLOADN(A,A1)		!A1 is in (0 + 2) = 2 to N - 1 = (1*(N1 - 2) + 2).
            CALL BIGMODEXP(X,N,A,D)		!X = A**D mod N.
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
        END FUNCTION BIGMRPRIME	!Are some numbers resistant to this scheme?

        INTEGER FUNCTION BIGFACTOR(B,LIMIT)	!Find the first factor of B. Limited assault.
Careful. The 32-bit integer limit is 2,147,483,647. P(1358124) = 21,474,829 and BIGBASE might be 100.
         USE PRIMEBAG	!I want a supply.
         TYPE(BIGNUM) B	!The number to factorise.
         INTEGER LIMIT	!A limit on the search.
         REAL*8 S	!The square root of B.
         INTEGER F	!A candidate factor.
          S = SQRT(BIGVALUE(B))	!Pious hope for accuracy...
          F = 2		!Here we go.
          DO WHILE(F.LE.S)	!Thus avoid declaring 2 to have a factor of 2.
            IF (BIGMODN(B,F).EQ.0) THEN	!Divisible?
              BIGFACTOR = F		!Yes!
              RETURN			!Done.
            END IF		!But otherwise,
            F = NEXTPRIME(F)	!Find the next prime number.
            IF (F.LE.0 .OR. F.GT.LIMIT) THEN	!Overflow? Or, too far already?
              BIGFACTOR = 0		!Alas. Sez: Don't know.
c              WRITE (6,1) LIMIT,F,S	!Make a report.
    1         FORMAT ("Passed the limit of ",I0," with ",I0,
     1         ", but Sqrt(n) =",E16.8)
              IF (BIGMRPRIME(B,BIGMRTRIALS)) THEN	!Crank up a Miller-Rabin probe.
                BIGFACTOR = -1		!Non-priminess not observed in this probe.
               ELSE			!Or possibly,
                BIGFACTOR = -2		!Non-primeness definitely observed.
              END IF			!That was mysterious.
              RETURN			!Pass the word..
            END IF		!But otherwise,
          END DO	!Consider the next factor.
          BIGFACTOR = 1	!If we pass SQRT(B), B is definitely prime.
        END FUNCTION BIGFACTOR	!The first factor suffices.

      END MODULE BIGNUMBERS	!No fancy tricks.
